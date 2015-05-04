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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddMembersViewController *vc = [segue destinationViewController];
    vc.family = _familiaNueva;
    vc.delegate = _delegate;
}

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
                            _oNewName.text = @"Error al agregar la familia al usuario.";
                        }
                        
                    }];
                } else {
                    _oNewName.text = @"Error al agregar la familia a la base de datos.";
                }
            }];
            
            
            // call the segue
            
        }else {
            _oNewName.text = @"Esa familia ya existe.";
        }
    }
}
@end
