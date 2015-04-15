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
    NSInteger index = [self.pri integerValue] - 1;
    [self.btnPriority setSelectedSegmentIndex: index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender {
    self.task = self.txtTask.text;
    int theInteger;
    theInteger = [self.btnPriority selectedSegmentIndex] + 1;
    NSNumber *myNumber = [NSNumber numberWithInt: theInteger];
    self.pri = [myNumber stringValue];
    
    [self.delegate updateTask: self.oldTask withNewName: self.task withPriority: self.pri];
}

- (IBAction)delete:(id)sender {
    [self.delegate deleteTask: self.oldTask];
}

- (IBAction)complete:(id)sender {
    [self.delegate completeTask: self.oldTask withPriority: self.pri];
}

@end