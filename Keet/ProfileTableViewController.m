//
//  ProfileTableViewController.m
//  Keet
//
//  Created by Eduardo Cristerna on 24/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "UserTableViewCell.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserCellFromDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Database

-(void)initUserCellFromDatabase {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PFQuery *query = [PFQuery queryWithClassName: @"User"];
    [query selectKeys: @[@"username"]];
    [query whereKey: @"email" equalTo: appDelegate.user];

    PFObject *user = [query getFirstObject];
    
    self.userCell.lblUsername.text = user[@"username"];
    self.userCell.lblEmail.text = appDelegate.user;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
