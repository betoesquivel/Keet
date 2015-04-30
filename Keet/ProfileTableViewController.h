//
//  ProfileTableViewController.h
//  Keet
//
//  Created by Eduardo Cristerna on 24/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTableViewCell.h"

@interface ProfileTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UserTableViewCell *userCell;

@end