//
//  DataProcess.m
//  Stacky
//
//  Created by Ravi Prakash on 11/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#define Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "DataProcess.h"
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
    
    NSString *print = [NSString stringWithFormat:@"question title is : %@",[items objectForKey:@"title"]];
    NSLog(@"%@",print);
    
    
    return resultOfSearch;
}

-(void) createData:(NSString *)searchText : (NSString *)objecKey  {
    NSString *apiCall = [self getApiCall:searchText]; // remove gUserTextForSearch
    //NSLog(@"%@",apiCall);
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiCall]];
    _data = [self fetchDataFromInternet:responseData :objecKey];
}


-(NSDictionary *) getTestData : (NSInteger ) row {
    
    // json data sould be like that
    //_data = @[@{@"title":@"jeff" , @"answer_count":@"15"}  ,  @{@"title": @"asdfsdfgdsfgsdfgcxg sdfsfasdfasdfsad asd asdf asdfasdfasdf"  ,   @"answer_count":@"15"}   ,  @{@"title": @"xgxcv" ,   @"answer_count":@"10"},  @{@"title":@"erd" , @"answer_count": @"11"},@{@"title":@"fghfg" , @"answer_count":@"18"},@{@"title":@"hfg" , @"answer_count":@"10"},];
    return _data[row];
}

@end


/*dispatch_async(Queue, ^{
 NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stackOverFlowQuestionUrl]];
 });*/