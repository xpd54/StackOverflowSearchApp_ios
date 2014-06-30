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
#import "viewIndicatorViewController.h"
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
    
    //hide right bar button
    [self hideDoneBarButton:YES];
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
    NSString *currentQuestionId = [que valueForKey:@"question_id"];
    _currentQuestionUrl = @"http://stackoverflow.com/questions/";
    _currentQuestionUrl = [_currentQuestionUrl stringByAppendingString:currentQuestionId];
    
    
    NSString *acceptedAnswerId = [que valueForKeyPath:@"accepted_answer_id"];
    _currentAcceptedAnswerUrl = @"http://stackoverflow.com/a/";
    _currentAcceptedAnswerUrl = [_currentAcceptedAnswerUrl stringByAppendingString:acceptedAnswerId];
    [self userChoiceView];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"test");
    NSInteger page = [DataProcess getPageValue];
    NSInteger pageSize = [DataProcess getPageSize];
    NSString *searchText = [DataProcess getSearchString];
    page++;
    [_getDataFromDataBase createDataAndAck:searchText objectName:@"items" entityName:@"Question" withPageNumber:page andPageSize:pageSize];
    [_getDataFromDataBase fetchAndSetData];
    [self.tableView reloadData];
}



- (void)loadUIWebView : (NSString *) currentURL {
    InternetConnection *connection = [[InternetConnection alloc]init];
    if ([connection checkInternetConnection]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]]];
        webView.tag = 2;
        [self.view addSubview:webView];
    } else {
        Alert *noInternet = [[Alert alloc] init];
        [noInternet showAlertsForInterConnection];
    }
}

-(void) userChoiceView {
    [self hideBackBarButton:YES]; // hiding back button
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    UIView *transparetSubView = [[UIView alloc] initWithFrame:self.view.bounds];
    transparetSubView.tag = 3;
    transparetSubView.backgroundColor = [UIColor blackColor];
    transparetSubView.alpha = 0.8;
    transparetSubView.opaque = NO;
    
    
    UIColor *colorOfButtonBacground = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1.5f];
    
    //Button setting for all Answer button
    
    UIButton *choiceFullAnswer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    choiceFullAnswer.frame = CGRectMake(10, self.view.center.y, 140, 40);
    choiceFullAnswer.tag = 4;
    [choiceFullAnswer setShowsTouchWhenHighlighted:YES];
    [choiceFullAnswer setTitle:@"All Answers" forState:UIControlStateNormal];
    choiceFullAnswer.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [choiceFullAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [choiceFullAnswer setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [choiceFullAnswer setBackgroundColor:colorOfButtonBacground];
    [choiceFullAnswer addTarget:self action:@selector(showFullAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    //Button setting for accepted Answer
    
    UIButton *choiceAcceptedAnswer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    choiceAcceptedAnswer.frame = CGRectMake(170, self.view.center.y, 140, 40);
    choiceAcceptedAnswer.tag = 5;
    [choiceAcceptedAnswer setShowsTouchWhenHighlighted:YES];
    [choiceAcceptedAnswer setTitle:@"Accepted Answer" forState:UIControlStateNormal];
    choiceAcceptedAnswer.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [choiceAcceptedAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [choiceAcceptedAnswer setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [choiceAcceptedAnswer setBackgroundColor:colorOfButtonBacground];
    [choiceAcceptedAnswer addTarget:self action:@selector(showAcceptedAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:transparetSubView];
    [transparetSubView addSubview:choiceAcceptedAnswer];
    [transparetSubView addSubview:choiceFullAnswer];
    
    //stop scrolling of table View
    
    self.tableView.scrollEnabled = NO;
}



-(IBAction)showFullAnswer:(id)sender {
    
    [self hideBackBarButton:YES];
    
    viewIndicatorViewController *indicator = [[viewIndicatorViewController alloc] init];
    InternetConnection *connection = [[InternetConnection alloc]init];
    UIView *choiceViewToRemove = [self.view viewWithTag:3];
    [choiceViewToRemove removeFromSuperview];
    [indicator startAnimation:self];
    sleep(1);
    if ([connection checkInternetConnection]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.tag = 2;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_currentQuestionUrl]]];
        [self.view addSubview:webView];
        [indicator removeIndicator:self];
    } else {
        [indicator removeIndicator:self];
        Alert *noInternet = [[Alert alloc] init];
        [noInternet showAlertsForInterConnection];
        //reload the table view to remove previous selected cell
        [self.tableView reloadData];
    }

}


-(IBAction)showAcceptedAnswer:(id)sender {
    [self hideBackBarButton:YES];
    
    viewIndicatorViewController *indicator = [[viewIndicatorViewController alloc]init];
    InternetConnection *connection = [[InternetConnection alloc]init];
    UIView *choiceViewToRemove = [self.view viewWithTag:3];
    [choiceViewToRemove removeFromSuperview];
    [indicator startAnimation:self];
    sleep(1);
    if ([connection checkInternetConnection]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.tag = 2;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_currentAcceptedAnswerUrl]]];
        [self.view addSubview:webView];
        [indicator removeIndicator:self];
    } else {
        [indicator removeIndicator:self];
        Alert *noInternet = [[Alert alloc] init];
        [noInternet showAlertsForInterConnection];
        //reload the table view to remove previous selected cell
        [self.tableView reloadData];
    }
}

-(void) hideBackBarButton : (BOOL) show {
    if (show) {
       self.navigationItem.hidesBackButton = YES;
    }
    else {
       self.navigationItem.hidesBackButton = NO;
    }
    
}

-(void) hideDoneBarButton : (BOOL) show {
    if (show) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    else
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (IBAction)close:(id)sender {
    UIView *viewToRemove = [self.view viewWithTag:2];
    UIView *choiceViewToRemove = [self.view viewWithTag:3];
    [viewToRemove removeFromSuperview];
    [choiceViewToRemove removeFromSuperview];
    //reload the table view to remove previous selected cell
    [self.tableView reloadData];
    //scrolling view enable
    self.tableView.scrollEnabled = YES;
    [self hideBackBarButton:NO];
    [self hideDoneBarButton:YES];
}
@end