//
//  viewIndicatorViewController.m
//  Stacky
//
//  Created by Ravi Prakash on 18/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//

#import "viewIndicatorViewController.h"

@interface viewIndicatorViewController ()

@end

@implementation viewIndicatorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) startAnimation : (UIViewController *) viewOfIndicator {
    [self performSelectorInBackground:@selector(activityIndicator:) withObject:viewOfIndicator];
}

-(void) activityIndicator : (UIViewController *)viewOfIndicator {
    UIView *transparetSubView = [[UIView alloc] initWithFrame:viewOfIndicator.view.bounds];
    transparetSubView.tag = 6;
    transparetSubView.backgroundColor = [UIColor blackColor];
    transparetSubView.alpha = 0.8;
    transparetSubView.opaque = NO;
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(viewOfIndicator.view.center.x,viewOfIndicator.view.center.y, 0.0f, 0.0f)];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityIndicator startAnimating];
    [transparetSubView addSubview:_activityIndicator];
    [viewOfIndicator.view addSubview:transparetSubView];
}

-(UIActivityIndicatorView *) getIndicatorWithPositionOfX:(float) x andY:(float) y {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, 0.0f, 0.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    return activityIndicator;
}

-(void) removeIndicator : (UIViewController *) viewOfIndicator {
    [_activityIndicator stopAnimating];
    UIView *viewToRemove = [viewOfIndicator.view viewWithTag:6];
    [viewToRemove removeFromSuperview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
