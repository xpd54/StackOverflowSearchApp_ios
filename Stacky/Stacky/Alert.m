//
//  Alert.m
//  Stacky
//
//  Created by Ravi Prakash on 16/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//

#import "Alert.h"

@implementation Alert
-(void) showAlertsForInterConnection {
    UIAlertView *internetConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Internet Connection" message:@"You don't have Internet Connection \n Try Again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [internetConnectionAlert show];
}

-(void) showDatabaseMissingWithSearchText:(NSString *)searchText {
    NSString *popupMessage = [[NSString alloc] initWithFormat:@"You Don't Have Any Offline Data %@",searchText];
    UIAlertView *databaseMissing = [[UIAlertView alloc] initWithTitle:@"Database Missing" message:popupMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [databaseMissing show];
}

-(void) showOfflineResultWithSearchText:(NSString *)searchText {
    NSString *popupMessage = [[NSString alloc] initWithFormat:@"Showing Offline Result For %@",searchText];
    UIAlertView *offlineResult = [[UIAlertView alloc] initWithTitle:@"Offline Data" message:popupMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [offlineResult show];
}
@end
