//
//  MembersTableViewController.h
//  Keet
//
//  Created by Eduardo Cristerna on 24/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MembersTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *names;

@property (strong, nonatomic) NSMutableArray *emails;

@property (strong, nonatomic) NSMutableArray *points;

@end