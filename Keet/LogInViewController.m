//
//  LogInViewController.m
//  Keet
//
//  Created by Eduardo Cristerna on 15/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "LogInViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import <Parse/Parse.h>

@interface LogInViewController ()

@property BOOL valido;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.valido = FALSE;
    self.lblMessage.text = @"";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(quitKeyboard)];
    [self.view addGestureRecognizer: tap];
    
    self.txtUser.text = @"";
    self.txtPassword.text = @"";
    
    self.txtUser.delegate = self;
    self.txtPassword.delegate = self;
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard

- (void) quitKeyboard {
    [self.view endEditing: YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual: self.txtPassword]) {
        [textField resignFirstResponder];
        
        [self logIn: nil];
    }
    else {
        NSInteger nextTag = textField.tag + 1;
        UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
        [nextResponder becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark - Database

- (BOOL) verifyLogInInDatabase {
    NSString *user = self.txtUser.text;
    NSString *password = self.txtPassword.text;
    
    PFQuery *query = [PFQuery queryWithClassName: @"User"];
    [query includeKey:@"familias"];
    [query whereKey: @"email" equalTo: user];
    [query whereKey: @"password" equalTo: password];
    
    PFObject *result = [query getFirstObject];
    
    if (result) {
        self.valido = TRUE;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.user = user;
        appDelegate.family = result[@"familia"];
        appDelegate.usuario = result;
        appDelegate.familias = result[@"familias"];
        
        // temp code to fill the db
        // find out if my families array contains the current family
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"nombre", appDelegate.family];
        NSArray *familias = appDelegate.familias;
        PFObject *currentFamily;
        if (!familias) {
            PFQuery *checkFamily = [PFQuery queryWithClassName:@"Familia"];
            [checkFamily whereKey:@"nombre" equalTo:appDelegate.family];
            PFObject *resultFamily = [checkFamily getFirstObject];
            
            // the family doesn't exist.... add it
            if (!resultFamily){
                // the current family is not added in the array
                currentFamily = [PFObject objectWithClassName: @"Familia"];
                currentFamily[@"nombre"] = appDelegate.family;
                currentFamily[@"createdBy"] = appDelegate.usuario;
            }else {
                currentFamily = resultFamily;
            }
            
            [result addObject:currentFamily forKey:@"familias"];
            // add the family
            [result saveInBackground];
            
        }else {
            currentFamily = [[familias filteredArrayUsingPredicate:predicate] objectAtIndex:0];
        }
        appDelegate.familia = currentFamily;

        
    }

    return self.valido;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)unwind:(UIStoryboardSegue *)segue {
    [self viewDidLoad];
}

#pragma mark - Button Actions

- (IBAction)logIn:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        self.lblMessage.text = @"Sin conexión a internet Vuelva a abrir la aplicación";
        self.btnLogIn.enabled = NO;
        self.btnSubscribe.enabled = NO;
    } else {
        self.btnLogIn.enabled = YES;
        self.btnSubscribe.enabled = YES;
        
        if ([self verifyLogInInDatabase])
            [self.btnLogged sendActionsForControlEvents: UIControlEventTouchUpInside];
        else
            self.lblMessage.text = @"Usuario o contraseña inválidos";
    }
}

#pragma mark - Scroll View

- (void)registerForKeyboardNotifications {
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