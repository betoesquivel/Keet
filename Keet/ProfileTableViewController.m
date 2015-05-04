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

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor: UIColorFromRGB(0x71C6EF)];
    [self.navigationController.navigationBar setTintColor: UIColorFromRGB(0xF3812D)];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : UIColorFromRGB(0xF3812D)}];
    
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

@end