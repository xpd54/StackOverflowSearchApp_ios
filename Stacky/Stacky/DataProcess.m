//
//  DataProcess.m
//  Stacky
//
//  Created by Ravi Prakash on 11/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#import "DataProcess.h"
#import <CoreData/CoreData.h>
@implementation DataProcess

static NSString *CellIdentifier = @"CellIdentifier";

-(NSString *) getApiCall : (NSString *) userTextForSearch {
    _beforeUserInput = @"http://api.stackexchange.com/2.2/search/advanced?order=desc&sort=activity&q=";
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

-(void) createData:(NSString *)searchText : (NSString *)objecKey  {
    NSString *apiCall = [self getApiCall:searchText];
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiCall]];
    [self saveDataInDataBase:[self fetchDataFromInternet:responseData :objecKey]];

}

-(void) saveDataInDataBase : (NSArray *) dataFromInternate {
    [self deleteOldData:@"Question"]; // delete old data from data base
    for(int i = 0; i < [dataFromInternate count];i++) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
        NSDictionary *currentData = [dataFromInternate objectAtIndex:i];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"title"]]  forKey:@"title"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"question_id"]]  forKey:@"question_id"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"answer_count"]]  forKey:@"answer_count"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"accepted_answer_id"]]  forKey:@"accepted_answer_id"];;
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    gArray = [self fetcheDataFromDataBase:@"Question"];
}


// reading data from database

-(NSArray *) fetcheDataFromDataBase : (NSString *) entityName {
    NSArray *fetchedData;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchedData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    return fetchedData;
}

//delete old data form data Base

-(void) deleteOldData : (NSString *) entityName {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *allQuestion = [[NSFetchRequest alloc] init];
    [allQuestion setEntity:[NSEntityDescription entityForName:@"Question" inManagedObjectContext:managedObjectContext]];
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