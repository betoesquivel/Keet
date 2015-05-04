//
//  CreateFamilyViewController.h
//  Keet
//
//  Created by José Alberto Esquivel on 5/4/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddMembersViewController.h"
@interface CreateFamilyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oNewName;
@property (weak, nonatomic) IBOutlet UIButton *oSegueButton;
@property (strong, nonatomic) PFObject *familiaNueva;
@property (strong, nonatomic) id<RegresarAHome> delegate;
- (IBAction)createFamily:(id)sender;

@end
