//
//  InternetConnection.m
//  Stacky
//
//  Created by Ravi Prakash on 16/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//

#import "InternetConnection.h"
#import "Reachability.h"
@implementation InternetConnection
-(BOOL) checkInternetConnection {
    Reachability *network = [Reachability reachabilityWithHostName:@"stackexchange.com"];
    NetworkStatus netStatus = [network currentReachabilityStatus];
    if (netStatus == NotReachable) {
        return NO;
    }
    else
        return YES;
    
}
@end
