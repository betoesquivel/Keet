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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(quitarTeclado)];
    [self.view addGestureRecognizer: tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) quitarTeclado {
    [self.view endEditing: YES];
}

#pragma mark - Database

- (BOOL)saveUser {
    if ([self verifyUser: self.txtEmail.text]) {
        PFObject *user = [PFObject objectWithClassName: @"User"];
        user[@"username"] = self.txtUser.text;
        user[@"password"] = self.txtPassword.text;
        user[@"email"] = self.txtEmail.text;
        user[@"familia"] = self.txtFamily.text;
        
        [user saveInBackground];
        
        return true;
    }
    
    self.lblMessage.text = @"Este correo ya está dado de alta";
    
    return false;
}

- (BOOL)verifyUser: (NSString *)email {
    PFQuery *query = [PFQuery queryWithClassName: @"User"];
    [query whereKey: @"email" equalTo: email];
    
    PFObject *result = [query getFirstObject];
    
    if (result)
        return false;
    
    return true;
}

- (IBAction)btnSubscribe:(id)sender {
    if ([self.txtEmail.text isEqualToString: @""] || [self.txtUser.text isEqualToString: @""] || [self.txtFamily.text isEqualToString: @""] || [self.txtPassword.text isEqualToString: @""])
        self.lblMessage.text = @"Por favor llene todo los campos";
    else if ([self saveUser])
        [self.btnUnwind sendActionsForControlEvents: UIControlEventTouchUpInside];
}

@end