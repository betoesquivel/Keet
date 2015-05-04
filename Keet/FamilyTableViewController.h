//
//  FamilyTableViewController.h
//  Keet
//
//  Created by José Alberto Esquivel on 5/4/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface FamilyTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *families;
@property (strong, nonatomic) AppDelegate *appDelegate;
@end
