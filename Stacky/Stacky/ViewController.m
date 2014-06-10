//
//  ViewController.m
//  Stacky
//
//  Created by Ravi Prakash on 09/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//

#import "ViewController.h"
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

// close the apps

- (IBAction)exitButton:(id)sender {
    exit(0);
}

// getting search text from user 

- (IBAction)searchButton:(id)sender {
    NSLog(@"%@",self.searchText.text);
}

@end
