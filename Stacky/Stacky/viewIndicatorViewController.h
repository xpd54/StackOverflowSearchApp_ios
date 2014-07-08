//
//  viewIndicatorViewController.h
//  Stacky
//
//  Created by Ravi Prakash on 18/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface viewIndicatorViewController : UIViewController
@property UIActivityIndicatorView *activityIndicator;
-(void) startAnimation : (UIViewController *) viewOfIndicator;
-(void) removeIndicator : (UIViewController *) viewOfIndicator;
-(UIActivityIndicatorView *) getIndicatorWithPositionOfX:(float) x andY:(float) y;
@end
