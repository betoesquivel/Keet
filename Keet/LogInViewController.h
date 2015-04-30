//
//  LogInViewController.h
//  Keet
//
//  Created by Eduardo Cristerna on 15/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtUser;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@property (weak, nonatomic) IBOutlet UIButton *btnLogged;

- (IBAction)logIn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;

@property (weak, nonatomic) IBOutlet UIButton *btnSubscribe;

@property (nonatomic, strong) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end