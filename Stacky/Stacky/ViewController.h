//
//  ViewController.h
//  Stacky
//
//  Created by Ravi Prakash on 09/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "QuestionTableViewController.h"
@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *searchText;
- (IBAction)exitButton:(id)sender;
- (IBAction)searchButton:(id)sender;
- (IBAction)backGroundTap:(id)sender;

@end
