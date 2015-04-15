//
//  DetailTaskViewController.m
//  Keet
//
//  Created by Eduardo Cristerna on 15/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "DetailTaskViewController.h"
#import "TasksViewController.h"
#import <Parse/Parse.h>

@interface DetailTaskViewController ()

@end

@implementation DetailTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtList.text = self.list;
    self.txtTask.text = self.oldTask;
    self.btnPriority.selectedSegmentIndex = [self.priority integerValue] - 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender {
    self.task = self.txtTask.text;
    int theInteger;
    theInteger = [self.btnPriority selectedSegmentIndex];
    NSNumber *myNumber = [NSNumber numberWithInt: theInteger];
    self.priority = [myNumber stringValue];
    
    [self updateTaskToDatabase];
    
    [self.delegado quitaVista];
}

- (IBAction)delete:(id)sender {
    [self deleteTaskFromDatabase];
    
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Database

- (void)updateTaskToDatabase {
    NSLog(self.oldTask);
    PFQuery *query = [PFQuery queryWithClassName: @"Tarea"];
    [query whereKey: @"nombre" equalTo: self.oldTask];
    NSLog(self.oldTask);
    [query getFirstObjectInBackgroundWithBlock: ^(PFObject *tasks, NSError *error) {
        if (!error) {
            NSLog(self.oldTask);
            [tasks setObject: self.task forKey: @"nombre"];
            [tasks setObject: self.priority forKey: @"prioridad"];
            
            [tasks saveInBackground];
            NSLog(self.oldTask);
        }
    }];
    NSLog(self.oldTask);
}

- (void)deleteTaskFromDatabase {
    
}

@end