//
//  ViewController.m
//  Stacky
//
//  Created by Ravi Prakash on 09/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#import "ViewController.h"
#import "DataProcess.h"
#import "Helpshift.h"
#import "InternetConnection.h"
#import "Alert.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// close the keyboard

- (IBAction)backGroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)helpButton:(id)sender {
    [[Helpshift sharedInstance] showFAQs:self withOptions:@{@"enableContactUs":@"AFTER_VIEWING_FAQS"}];
}

// close the apps

- (IBAction)exitButton:(id)sender {
    exit(0);
}


-(void) activityIndicator : (NSString *) show {

    [self.view addSubview:_activityIndicator];
    if ([show isEqualToString:@"yes"]) {
        [_activityIndicator startAnimating];
    } else {
        _activityIndicator.hidden = YES;
        [_activityIndicator stopAnimating];
    }
}

-(void) dataFromInternet {
    DataProcess *dataFromInternet = [[DataProcess alloc] init];
    _isDataFound = [NSString stringWithString:[dataFromInternet createDataAndAck:self.searchText.text :@"items" :@"Question"]];
}

// getting search text from user
- (IBAction)searchButton:(id)sender {
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x,self.view.center.y, 0.0f, 0.0f)];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    
    [self dataFromInternet];
    if ([_isDataFound isEqualToString:@"yes"]) {
        [self performSegueWithIdentifier:@"moveToQuestionList" sender:sender];
    }
    if ([_isDataFound isEqualToString:@"no"]) {
        InternetConnection *connection = [[InternetConnection alloc] init];
        if ([connection checkInternetConnection] == YES) {
            Alert *noDataForSearch = [[Alert alloc] init];
            [noDataForSearch showErrorForNoSearchData];
        } else {
            Alert *noInternetConnection = [[Alert alloc] init];
            [noInternetConnection showAlertsForInterConnection];
        }
    }
}

@end
