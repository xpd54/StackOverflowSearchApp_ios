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
#import "viewIndicatorViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
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

-(void) dataFromInternet {
    NSInteger page = 1;
    NSInteger pageSize = 10;
    DataProcess *dataFromInternet = [[DataProcess alloc] init];
    //_isDataFound = [NSString stringWithString:[dataFromInternet createDataAndAck:self.searchText.text :@"items" :@"Question":page:pageSize]];
    _isDataFound = [NSString stringWithString:[dataFromInternet createDataAndAck:self.searchText.text objectName:@"items" entityName:@"Question" withPageNumber:page andPageSize:pageSize]];
}

// getting search text from user
- (IBAction)searchButton:(id)sender {
    viewIndicatorViewController *indicator = [[viewIndicatorViewController alloc] init];
    
    [indicator startAnimation:self];
    [self dataFromInternet];
    
    if ([_isDataFound isEqualToString:@"yes"]) {
        [indicator removeIndicator:self];
        [self performSegueWithIdentifier:@"moveToQuestionList" sender:sender];
    }
    if ([_isDataFound isEqualToString:@"no"]) {
        InternetConnection *connection = [[InternetConnection alloc] init];
        if ([connection checkInternetConnection] == YES) {
            [indicator removeIndicator:self];
            Alert *noDataForSearch = [[Alert alloc] init];
            [noDataForSearch showErrorForNoSearchData];
        } else {
            [indicator removeIndicator:self];
            Alert *noInternetConnection = [[Alert alloc] init];
            [noInternetConnection showAlertsForInterConnection];
        }
    }
}

@end
