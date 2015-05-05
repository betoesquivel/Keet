//
//  CreateFamilyViewController.m
//  Keet
//
//  Created by José Alberto Esquivel on 5/4/15.
//
//

#import "CreateFamilyViewController.h"
#import <Parse/Parse.h>
#import "AddMembersViewController.h"
#import "AppDelegate.h"
@interface CreateFamilyViewController ()

@end

@implementation CreateFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oNewName.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual: self.oNewName]) {
        [textField resignFirstResponder];
        
        [self createFamily: nil];
    }
    
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddMembersViewController *vc = [segue destinationViewController];
    vc.family = _familiaNueva;
    vc.delegate = _delegate;
}

#pragma mark - Database

- (IBAction)createFamily:(id)sender {
    if ([_oNewName.text length] > 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"Familia"];
        [query whereKey:@"nombre" equalTo:_oNewName.text];
        _familiaNueva = [query getFirstObject];
        if (!_familiaNueva) {
            _familiaNueva = [PFObject objectWithClassName:@"Familia"];
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            _familiaNueva[@"nombre"] = _oNewName.text;
            _familiaNueva[@"createdBy"] = appDelegate.usuario;
            [_familiaNueva saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [appDelegate.usuario addObject:_familiaNueva forKey:@"familias"];
                    [appDelegate.usuario saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded) {
                            [_oSegueButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                        }else {
                            _oNewName.text = @"Error al agregar la familia al usuario";
                        }
                        
                    }];
                } else {
                    _oNewName.text = @"Error al agregar la familia a la base de datos";
                }
            }];
            
            
            // call the segue
            
        }else {
            self.lblMessage.text = @"Esta familia ya existe";
        }
    }
}

@end