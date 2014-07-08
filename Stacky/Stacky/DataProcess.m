//
//  DataProcess.m
//  Stacky
//
//  Created by Ravi Prakash on 11/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#import "DataProcess.h"
#import "InternetConnection.h"
#import "Alert.h"
#import <CoreData/CoreData.h>
@implementation DataProcess
static NSString *searchStringFromUser;
static NSInteger page;
static NSInteger pageSize;
+(NSString *) getSearchString {
    return searchStringFromUser;
}

+(NSInteger ) getPageValue {
    return page;
}

+(NSInteger ) getPageSize {
    return pageSize;
}
-(NSArray *) getData {
    return _data;
}
-(NSString *) getApiCall : (NSString *) userTextForSearch {
    _beforeUserInput = @"http://api.stackexchange.com/2.2/search/advanced?";
    _beforeUserInput = [_beforeUserInput stringByAppendingFormat:@"page=%li&pagesize=%i&order=desc&sort=activity&q=",(long)page,pageSize];
    _beforeUserInput = [_beforeUserInput stringByAppendingString:userTextForSearch];
    _afterUserInput = @"&accepted=True&site=stackoverflow&filter=!0S26i4L6gvyVQBhi(jD)OK210";
    _questionApiCallUrl = [_beforeUserInput stringByAppendingString:_afterUserInput];
    NSString *url = [_questionApiCallUrl stringByAddingPercentEscapesUsingEncoding:
                     NSASCIIStringEncoding]; // Encoding of url string
    return url;
}

// Fetching Data from Internet
-(NSArray *) fetchDataFromInternet:(NSData *)responseData : (NSString *)objectKey {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* resultOfSearch = [json objectForKey:objectKey];
    return resultOfSearch;
}


//creating data and saving it in database

-(NSString *) createDataAndAck:(NSString *)searchText objectName: (NSString *)objecKey entityName:(NSString *)entityName withPageNumber: (NSInteger)pg andPageSize: (NSInteger)pgSz {
    page = pg;
    pageSize = pgSz;
    searchStringFromUser = [[NSString alloc] initWithString:searchText];// need to resolve further
    
    InternetConnection *connection = [[InternetConnection alloc] init];
    NSString *yes = @"yes";
    NSString *no = @"no";
    if ([connection checkInternetConnection]==YES) {
        NSString *apiCall = [self getApiCall:searchText];
        NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiCall]];
        [self saveDataInDataBase:[self fetchDataFromInternet:responseData :objecKey] : searchText];
        
        NSArray *local = [self fetchDataFromDataBase:entityName :searchText];
        if ([local count] > 0) {
            return yes;
        }
        else {
            return no;
        }
    } else {
        NSArray *local = [self fetchDataFromDataBase:entityName :searchText];
        if ([local count] > 0) {
            return yes;
        } else {
            return no;
        }
    }
    return no;
}

-(void) saveDataInDataBase : (NSArray *) dataFromInternate : (NSString *)searchText {
    //delete old data and update with new one
    [self deleteOldData:@"Question" :searchText];
    for(int i = 0; i < [dataFromInternate count];i++) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
        NSDictionary *currentData = [dataFromInternate objectAtIndex:i];
        [newQuestion setValue:searchText forKey:@"search_string"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"title"]]  forKey:@"title"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"question_id"]]  forKey:@"question_id"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"answer_count"]]  forKey:@"answer_count"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"accepted_answer_id"]]  forKey:@"accepted_answer_id"];;
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
}

// reading data from database and setting it for that object
-(void) fetchAndSetData {
    _data = [self fetchDataFromDataBase:@"Question": searchStringFromUser];
    if([_data count] == 0) {
        Alert *dataMissing = [[Alert alloc] init];
        InternetConnection *connection = [[InternetConnection alloc] init];
        if ([connection checkInternetConnection]==NO) {
            [dataMissing showAlertsForInterConnection];
        }
        else {
            [dataMissing showErrorForNoSearchData];
            return;
        }
    }
}

-(NSArray *) fetchDataFromDataBase : (NSString *) entityName : (NSString *)searchText {
    NSArray *result;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:[NSPredicate predicateWithFormat:@"search_string == %@",searchText]];
    NSError *error = nil;
    result = [context executeFetchRequest:request error:&error];
    return result;
}


//delete old data form data Base


-(void) deleteOldData : (NSString *) entityName :(NSString *)searchText {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *allQuestion = [[NSFetchRequest alloc] init];
    
    [allQuestion setEntity:[NSEntityDescription entityForName:@"Question" inManagedObjectContext:managedObjectContext]];
    [allQuestion setPredicate:[NSPredicate predicateWithFormat:@"search_string == %@",searchText]];
    [allQuestion setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * questions = [managedObjectContext executeFetchRequest:allQuestion error:&error];
    //error handling goes here
    for (NSManagedObject * que in questions) {
        [managedObjectContext deleteObject:que];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    //more error handling here
}


-(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
@end