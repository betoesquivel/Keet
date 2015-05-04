//
//  UserDetailViewController.h
//  Keet
//
//  Created by Eduardo Cristerna on 24/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet UILabel *lblPoints;

@property (weak, nonatomic) IBOutlet UIImageView *contactImage;

@property (strong, nonatomic) NSString *points;

@property (strong, nonatomic) NSString *email;

@end