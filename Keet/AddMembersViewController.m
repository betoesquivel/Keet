//
//  AddMembersViewController.m
//  Keet
//
//  Created by José Alberto Esquivel on 5/4/15.
//
//

#import "AddMembersViewController.h"
#import <Parse/Parse.h>

@interface AddMembersViewController ()

@end

@implementation AddMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oEmail.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual: self.oEmail]) {
        [textField resignFirstResponder];
        
        [self addMember: nil];
    }
    
    return YES;
}

#pragma mark - Database

- (IBAction)addMember:(id)sender {
    if ([_oEmail.text length] > 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"familias" notEqualTo:_family];
        [query includeKey:@"familias"];
        [query whereKey:@"email" equalTo:_oEmail.text];
        PFObject *newMember= [query getFirstObject];
        if (!newMember) {
            self.lblMessage.text = @"No existe un usuario con ese correo o ya ha sido agregado a la familia";
        }else {
            [newMember addObject:_family forKey:@"familias"];
            [newMember saveInBackground];
            _oInfoLabel.text = [NSString stringWithFormat:@"%@ agregado", _oEmail.text];
        }
    }
}

#pragma mark - Navigation

- (IBAction)returnToHome:(id)sender {
    [_delegate quitaVista];
}

@end