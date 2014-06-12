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


-(NSArray *) fetchDataFromInternet:(NSData *)responseData : (NSString *)objectKey {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* resultOfSearch = [json objectForKey:objectKey];
    //NSLog(@"items: %@", resultOfSearch);
    NSDictionary *items = [resultOfSearch objectAtIndex:1];
    
    NSString *print = [NSString stringWithFormat:@"question title is : %@   %@",[items objectForKey:@"title"],[items objectForKey:@"accepted_answer_id"]];
    NSLog(@"%@",print);
    
    
    return resultOfSearch;
}

-(void) createData:(NSString *)searchText : (NSString *)objecKey  {
    NSString *apiCall = [self getApiCall:searchText]; // remove gUserTextForSearch
    //NSLog(@"%@",apiCall);
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiCall]];
    _data = [self fetchDataFromInternet:responseData :objecKey];
    
    /*for(int i = 0 ;i<[_data count];i++ ) {
        NSDictionary *currentData = [_data objectAtIndex:i];
        NSLog(@"%@ %d",[currentData objectForKey:@"question_id"],i);
    }*/
    [self saveDataInDataBase:_data];
}

-(void) saveDataInDataBase : (NSArray *) dataFromInternate {
    
    for(int i = 0; i < [dataFromInternate count];i++) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
        NSDictionary *currentData = [dataFromInternate objectAtIndex:i];
        //NSLog(@"%@",[currentData objectForKey:@"question_id"]);
        [newQuestion setValue:[currentData objectForKey:@"title"] forKey:@"title"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"question_id"]]  forKey:@"question_id"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"answer_count"]]  forKey:@"answer_count"];
        [newQuestion setValue:[NSString stringWithFormat:@"%@",[currentData objectForKey:@"accepted_answer_id"]]  forKey:@"accepted_answer_id"];;
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
}

-(NSDictionary *) getTestData : (NSInteger ) row {
    
    // json data sould be like that
    //_data = @[@{@"title":@"jeff" , @"answer_count":@"15"}  ,  @{@"title": @"asdfsdfgdsfgsdfgcxg sdfsfasdfasdfsad asd asdf asdfasdfasdf"  ,   @"answer_count":@"15"}   ,  @{@"title": @"xgxcv" ,   @"answer_count":@"10"},  @{@"title":@"erd" , @"answer_count": @"11"},@{@"title":@"fghfg" , @"answer_count":@"18"},@{@"title":@"hfg" , @"answer_count":@"10"},];
    NSLog(@"%ld",(long)row);
    NSDictionary *finalData = [_data objectAtIndex:row];
    NSLog(@"%@   %@",[finalData objectForKey:@"title"],[finalData objectForKey:@"answer_count"]);
    return finalData;
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