//
//  QuestionTableViewController.m
//  Stacky
//
//  Created by Ravi Prakash on 10/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "QuestionTableViewController.h"
#import "QuestionTableViewCell.h"
#import "DataProcess.h"
@interface QuestionTableViewController ()
@end

@implementation QuestionTableViewController
static NSString *CellIdentifier = @"CellIdentifier";
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _getDataFromDataBase=[[DataProcess alloc] init];
    [_getDataFromDataBase fetchAndSetData];
    UITableView *tableView = (id)[self.view viewWithTag:1];
    [tableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    // other method call is here
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [_getDataFromDataBase.data count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSManagedObject *queTable = [_getDataFromDataBase.data objectAtIndex:indexPath.row];
    cell.question = [queTable valueForKey:@"title"];
    cell.answerCount = [queTable valueForKey:@"answer_count"];
    
    
    
    //NSLog(@"%i",indexPath.row);
    //NSLog(@"%@",[queTable valueForKey:@"search_string"]);
    return cell;
}

@end
