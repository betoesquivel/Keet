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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addMember:(id)sender {
    if ([_oEmail.text length] > 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"familias" notEqualTo:_family];
        [query includeKey:@"familias"];
        [query whereKey:@"email" equalTo:_oEmail.text];
        PFObject *newMember= [query getFirstObject];
        if (!newMember) {
            _oInfoLabel.text = @"No existe un usuario con ese correo o ya ha sido agregado a la familia.";
        }else {
            [newMember addObject:_family forKey:@"familias"];
            [newMember saveInBackground];
            _oInfoLabel.text = [NSString stringWithFormat:@"%@ agregado", _oEmail.text];
        }
    }
}

- (IBAction)returnToHome:(id)sender {
    [_delegate quitaVista];
}
@end
