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

- (BOOL) verifyLogInInDatabase {
    NSString *user = self.txtUser.text;
    NSString *password = self.txtPassword.text;
    
    PFQuery *query = [PFQuery queryWithClassName: @"User"];
    [query whereKey: @"email" equalTo: user];
    [query whereKey: @"password" equalTo: password];
    [query selectKeys: @[@"username", @"password", @"familia"]];
    
    PFObject *result = [query getFirstObject];
    
    if (result) {
        self.valido = TRUE;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.user = user;
        appDelegate.family = result[@"familia"];
    }

    return self.valido;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)unwind: (UIStoryboardSegue *)segue {
    [self viewDidLoad];
}

- (IBAction)btnSubscribe:(id)sender {
    
}

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
@end