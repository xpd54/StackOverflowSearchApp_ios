//
//  DataProcess.h
//  Stacky
//
//  Created by Ravi Prakash on 11/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#import <Foundation/Foundation.h>
NSArray *gArray;  // search a solution to remove globel variable
@interface DataProcess : NSObject
@property (copy , nonatomic) NSString *beforeUserInput;
@property (copy , nonatomic) NSString *afterUserInput;
@property (copy , nonatomic) NSString *questionApiCallUrl;
@property (copy , nonatomic) NSArray *data;
-(NSString *) getApiCall : (NSString *) userTextForSearch;
-(NSArray *) fetchDataFromInternet : (NSData *)responseData : (NSString *)objectKey;
-(void) createData: (NSString *)searchText : (NSString *)objecKey;
-(NSArray *) fetcheDataFromDataBase : (NSString *) entityName;
@end
