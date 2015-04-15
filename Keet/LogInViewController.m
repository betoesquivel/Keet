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
    
    PFQuery *query = [PFQuery queryWithClassName: @"User"];
    [query whereKey: @"username" equalTo: user];
    [query whereKey: @"password" equalTo: password];
    [query selectKeys: @[@"username", @"password"]];
    
    PFObject *result = [query getFirstObject];

    if (result)
        self.valido = TRUE;

    return self.valido;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString: @"logIn"]) {
        if ([self shouldPerformSegueWithIdentifier: [segue identifier] sender: sender])
            NSLog(@"Hola");
    }
    else {
        NSLog(@"Hola");
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    [self verifyLogInInDatabase];
    
    return self.valido;
}

- (IBAction)unwind: (UIStoryboardSegue *)segue {
    self.valido = FALSE;
}

- (IBAction)btnSubscribe:(id)sender {
    self.valido = TRUE;
}
@end
