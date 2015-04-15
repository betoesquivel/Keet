//
//  LogInViewController.m
//  Keet
//
//  Created by Eduardo Cristerna on 15/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface LogInViewController ()

@property BOOL valido;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.valido = FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Database

- (BOOL) verifyLogInInDatabase {
    NSString *user = self.txtUser.text;
    NSString *password = self.txtPassword.text;
    
    //dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    PFQuery *query = [PFQuery queryWithClassName: @"User"];
    [query whereKey: @"username" equalTo: user];
    //[query whereKey: @"password" equalTo: password];
    [query getFirstObjectInBackgroundWithBlock: ^(PFObject *user, NSError *error) {
        if (!error) {
            self.valido = TRUE;
        }
        
        //dispatch_semaphore_signal(sema);
    }];
    
    //dispatch_semaphore_wait(sema, 10000);
    //dispatch_semaphore_signal(sema);
    
    return self.valido;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual: @"logIn"]) {
        if ([self shouldPerformSegueWithIdentifier: [segue identifier] sender: sender])
            NSLog(@"Hola");
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    [self verifyLogInInDatabase];
    
    return [self verifyLogInInDatabase];
}

@end
