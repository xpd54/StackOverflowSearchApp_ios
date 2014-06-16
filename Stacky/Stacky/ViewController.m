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

- (IBAction)searchButton:(id)sender {
    DataProcess *dataFromInternet = [[DataProcess alloc] init];
    [dataFromInternet createData: self.searchText.text :@"items"];
}

@end
