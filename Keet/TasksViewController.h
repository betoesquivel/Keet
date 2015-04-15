//
//  TasksViewController.h
//  Keet
//
//  Created by José Alberto Esquivel on 4/13/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksViewController : UITableViewController

@property (strong, nonatomic) NSString *list;

@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) NSString *task;

@property (strong, nonatomic) NSMutableArray *priority;

@end