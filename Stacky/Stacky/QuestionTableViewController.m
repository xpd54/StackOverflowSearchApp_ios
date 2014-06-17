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
#import "InternetConnection.h"
#import "Alert.h"
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
    self.tableView.delegate = self;
    // getting data from database
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
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *que = [_getDataFromDataBase.data objectAtIndex:indexPath.row];
    NSString *questionId = [que valueForKey:@"question_id"];
    NSString *currentURL = @"http://stackoverflow.com/questions/";
    currentURL = [currentURL stringByAppendingString:questionId];
    [self loadUIWebView:currentURL];
    NSLog(@"%@",questionId);
}
- (void)loadUIWebView : (NSString *) currentURL {
    InternetConnection *connection = [[InternetConnection alloc]init];
        if ([connection checkInternetConnection]) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]]];
            NSLog(@"%@",webView);
            webView.tag = 2;
            [self.view addSubview:webView];
    } else {
        Alert *noInternet = [[Alert alloc] init];
        [noInternet showAlertsForInterConnection];
    }
}
- (IBAction)close:(id)sender {
    UIView *viewToRemove = [self.view viewWithTag:2];
    [viewToRemove removeFromSuperview];
}
@end
