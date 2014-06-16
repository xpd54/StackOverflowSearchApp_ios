//
//  Alert.h
//  Stacky
//
//  Created by Ravi Prakash on 16/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject
-(void) showAlertsForInterConnection;
-(void) showDatabaseMissingWithSearchText:(NSString *)searchText ;
-(void) showOfflineResultWithSearchText:(NSString *)searchText;
-(void) showErrorForNoSearchData;
@end
