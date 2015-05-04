//
//  UserTableViewCell.h
//  Keet
//
//  Created by Eduardo Cristerna on 24/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@end