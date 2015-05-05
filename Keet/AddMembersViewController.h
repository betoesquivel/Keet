//
//  AddMembersViewController.h
//  Keet
//
//  Created by José Alberto Esquivel on 5/4/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol RegresarAHome <NSObject>
- (void) quitaVista;
@end

@interface AddMembersViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oEmail;
@property (weak, nonatomic) IBOutlet UILabel *oInfoLabel;
@property (strong, nonatomic) PFObject *family;
@property (strong, nonatomic) id <RegresarAHome> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
- (IBAction)addMember:(id)sender;
- (IBAction)returnToHome:(id)sender;


@end
