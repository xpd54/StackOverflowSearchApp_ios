//
//  DataProcess.h
//  Stacky
//
//  Created by Ravi Prakash on 11/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface DataProcess : NSObject
@property (copy , nonatomic) NSString *beforeUserInput;
@property (copy , nonatomic) NSString *afterUserInput;
@property (copy , nonatomic) NSString *questionApiCallUrl;
@property (copy , nonatomic) NSArray *data;
//@property NSInteger page;
//@property NSInteger pageSize;
+(NSString *) getSearchString;
+(NSInteger ) getPageValue;
+(NSInteger ) getPageSize;
-(NSString *) getApiCall : (NSString *) userTextForSearch;
-(NSArray *) fetchDataFromInternet : (NSData *)responseData : (NSString *)objectKey;
-(NSString *) createDataAndAck: (NSString *)searchText objectName: (NSString *)objecKey entityName: (NSString *)entityName withPageNumber: (NSInteger)page andPageSize: (NSInteger)pageSize;
-(NSArray *) fetchDataFromDataBase : (NSString *) entityName : (NSString *)searchText;
-(void) fetchAndSetData;
-(NSArray *) getData;
@end
