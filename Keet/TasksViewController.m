//
//  TasksViewController.m
//  Keet
//
//  Created by José Alberto Esquivel on 4/13/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "TasksViewController.h"
#import "DetailTaskViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface TasksViewController () <ProtocolDetailTask>

@end

@implementation TasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addButtonAction:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = self.list;
    
    [self loadDataFromDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - New Task

- (IBAction)addButtonAction:(id)sender {
    UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"Nueva Tarea"
                                                   message:@"Nombre de la Tarea"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancelar"
                                         otherButtonTitles:@"Crear", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[alert textFieldAtIndex:1] setSecureTextEntry: NO];
    
    UITextField *textFieldDescription = [alert textFieldAtIndex:0];
    textFieldDescription.placeholder = @"Nueva Tarea";
    UITextField *textFieldFileName = [alert textFieldAtIndex:1];
    textFieldFileName.placeholder = @"Número entre 1 - 3";
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        NSString *title = [alert textFieldAtIndex: 0].text;
        NSString *prioridad = [alert textFieldAtIndex: 1].text;
        
        if (title.length > 0) {
            if ([prioridad integerValue] >= 1 && [prioridad integerValue] <= 3)
                [self addTaskWithTitle: title prioridad: prioridad];
        }
    }
}

- (void)addTaskWithTitle: (NSString *)title prioridad: (NSString *)pri {
    [self.data addObject: title];
    [self.priority addObject: pri];

    [self.tableView reloadData];
    
    [self saveDataToDatabase: title prioridad: pri];
}

#pragma mark - Database

- (PFQuery *)loadDataFromDatabase {
    self.data = [[NSMutableArray alloc] init];
    self.priority = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName: @"Tarea"];
    [query whereKey:@"lista" equalTo: self.list];
    [query selectKeys: @[@"nombre", @"prioridad"]];
    [query orderByDescending: @"prioridad"];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *tasks, NSError *error) {
        if (tasks) {
            for (PFObject *task in tasks) {
                NSString *s = task[@"nombre"];
                NSString *p = task[@"prioridad"];
                [self.data addObject: s];
                [self.priority addObject: p];
                [self.tableView reloadData];
            }
        }
    }];
    
    return query;
}

- (void)saveDataToDatabase: (NSString *)title prioridad: (NSString *)pri {
    PFObject *task = [PFObject objectWithClassName:@"Tarea"];
    task[@"nombre"] = title;
    task[@"creador"] = @"Eduardo";
    task[@"lista"] = self.list;
    task[@"prioridad"] = pri;
    [task saveInBackground];
}

- (void)updateTaskToDatabase: (NSString *)title withNewTitle: (NSString *)newTitle withPriority: (NSString *)pri {
    PFQuery *query = [PFQuery queryWithClassName: @"Tarea"];
    [query whereKey: @"nombre" equalTo: title];
    [query whereKey: @"lista" equalTo: self.list];
    [query getFirstObjectInBackgroundWithBlock: ^(PFObject *tasks, NSError *error) {
        if (!error) {
            [tasks setObject: newTitle forKey: @"nombre"];
            [tasks setObject: pri forKey: @"prioridad"];
            
            [tasks saveInBackground];
        }
    }];
}

- (void)deleteTaskFromDatabase: (NSString *)title {
    PFQuery *query = [PFQuery queryWithClassName: @"Tarea"];
    [query whereKey: @"nombre" equalTo: title];
    [query whereKey: @"lista" equalTo: self.list];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *tasks, NSError *error) {
        if (tasks) {
            for (PFObject *task in tasks) {
                [task deleteInBackground];
            }
        }
    }];
}

- (void)completeTaskInDatabase:(NSString *)title withPriority: (NSString *)pri {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PFObject *task = [PFObject objectWithClassName: @"TareasCompletadas"];
    task[@"nombre"] = title;
    task[@"usuario"] = appDelegate.user;
    task[@"lista"] = self.list;
    task[@"prioridad"] = pri;
    [task saveInBackground];
    
    [self deleteTaskFromDatabase: title];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *subtitle = [[NSString alloc] initWithFormat: @"Prioridad "];
    subtitle = [subtitle stringByAppendingString: self.priority[indexPath.row]];
    
    cell.textLabel.text = self.data[indexPath.row];
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailTask"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = self.data[indexPath.row];
        NSString *pri = self.priority[indexPath.row];

        [[segue destinationViewController] setList: self.list];
        [[segue destinationViewController] setOldTask: object];
        [[segue destinationViewController] setPri: pri];
        [[segue destinationViewController] setDelegate: self];
    }
}

- (IBAction)unwind: (UIStoryboardSegue *)segue {
    
}

#pragma mark - Protocol Detail Task

- (void) updateTask: (NSString *)task withNewName: (NSString *)newTask withPriority: (NSString *)priority {
    NSInteger index = [self.data indexOfObject: task];
    
    [self.data removeObjectAtIndex: index];
    [self.priority removeObjectAtIndex: index];
    [self.data addObject: newTask];
    [self.priority addObject: priority];
    
    [self.tableView reloadData];
    [self updateTaskToDatabase: task withNewTitle:newTask withPriority: priority];
}

- (void) deleteTask: (NSString *)task {
    NSInteger index = [self.data indexOfObject: task];
    
    [self.data removeObjectAtIndex: index];
    [self.priority removeObjectAtIndex: index];
    
    [self.tableView reloadData];
    [self deleteTaskFromDatabase: task];
}

- (void) completeTask: (NSString *)task withPriority: (NSString *)priority {
    NSInteger index = [self.data indexOfObject: task];
    
    [self.data removeObjectAtIndex: index];
    [self.priority removeObjectAtIndex: index];
    
    [self.tableView reloadData];
    [self completeTaskInDatabase: task withPriority: priority];
}

@end