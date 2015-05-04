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
    
    self.lblList.text = self.list;
    self.txtTask.text = self.oldTask;
    NSInteger index = [self.pri integerValue] - 1;
    [self.btnPriority setSelectedSegmentIndex: index];
    self.navigationItem.title = self.oldTask;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(quitKeyboard)];
    [self.view addGestureRecognizer: tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard

- (void) quitKeyboard {
    [self.view endEditing: YES];
}

#pragma mark - Button Actions

- (IBAction)save:(id)sender {
    self.task = self.txtTask.text;
    NSInteger priority;
    priority = [self.btnPriority selectedSegmentIndex] + 1;
    self.pri = [[NSString alloc] initWithFormat: @"%ld", priority];
    
    [self.delegate updateTask: self.oldTask withNewName: self.task withPriority: self.pri];
    [self.btnUnwind sendActionsForControlEvents: UIControlEventTouchUpInside];
}

- (IBAction)delete:(id)sender {
    [self.delegate deleteTask: self.oldTask];
    [self.btnUnwind sendActionsForControlEvents: UIControlEventTouchUpInside];
}

- (IBAction)complete:(id)sender {
    [self.delegate completeTask: self.oldTask withPriority: self.pri];
    [self.btnUnwind sendActionsForControlEvents: UIControlEventTouchUpInside];
}

@end