//
//  QuestionTableViewController.h
//  Stacky
//
//  Created by Ravi Prakash on 10/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#import "DataProcess.h"
#import <UIKit/UIKit.h>
@interface QuestionTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (copy , nonatomic) DataProcess *getDataFromDataBase;
@property NSString *currentQuestionUrl;
@property NSString *currentAcceptedAnswerUrl;
- (IBAction)close:(id)sender;
@end
