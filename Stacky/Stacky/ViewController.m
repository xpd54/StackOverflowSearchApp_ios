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
#import "Reachability.h"
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

// getting search text from user 

-(void) showAlertsForInterConnection {
    UIAlertView *internetConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Internet Connection" message:@"You don't have Internet Connection \n Try Again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [internetConnectionAlert show];
}


- (IBAction)searchButton:(id)sender {
    [self.view endEditing:YES];
    DataProcess *dataFromInternet = [[DataProcess alloc] init];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self showAlertsForInterConnection];
    } else {
        [dataFromInternet createData: self.searchText.text :@"items"];
    }
}

@end
