//
//  SignUpViewController.m
//  Keet
//
//  Created by Eduardo Cristerna on 15/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Database

- (void)saveUser {
    PFObject *user = [PFObject objectWithClassName: @"User"];
    user[@"username"] = self.txtUser.text;
    user[@"password"] = self.txtPassword.text;
    user[@"email"] = self.txtEmail.text;
    [user saveInBackground];
}

- (IBAction)btnSubscribe:(id)sender {
    [self saveUser];
}

@end