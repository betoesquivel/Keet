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
    
    self.txtEmail.delegate = self;
    self.txtFamily.delegate = self;
    self.txtPassword.delegate = self;
    self.txtUser.delegate = self;
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) quitarTeclado {
    [self.view endEditing: YES];
}

- (IBAction)btnSubscribe:(id)sender {
    if ([self.txtEmail.text isEqualToString: @""] || [self.txtUser.text isEqualToString: @""] || [self.txtFamily.text isEqualToString: @""] || [self.txtPassword.text isEqualToString: @""])
        self.lblMessage.text = @"Por favor llene todo los campos";
    else if ([self saveUser])
        [self.btnUnwind sendActionsForControlEvents: UIControlEventTouchUpInside];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual: self.txtFamily]) {
        [textField resignFirstResponder];
        
        [self btnSubscribe: nil];
    }
    else {
        NSInteger nextTag = textField.tag + 1;
        UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
        [nextResponder becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark - Database

- (BOOL)saveUser {
    if ([self verifyUser: self.txtEmail.text]) {
        PFObject *user = [PFObject objectWithClassName: @"User"];
        user[@"username"] = self.txtUser.text;
        user[@"password"] = self.txtPassword.text;
        user[@"email"] = self.txtEmail.text;
        user[@"familia"] = self.txtFamily.text;
        user[@"puntos"] = @"0";
        
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

#pragma mark - Scroll View

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect bkgndRect = self.activeField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [self.activeField.superview setFrame:bkgndRect];
    [self.scrollView setContentOffset:CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height) animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect bkgndRect = self.activeField.superview.frame;
    bkgndRect.size.height -= kbSize.height;
    [self.activeField.superview setFrame:bkgndRect];
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

@end