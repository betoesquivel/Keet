//
//  TasksViewController.m
//  Keet
//
//  Created by José Alberto Esquivel on 4/13/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "TasksViewController.h"
#import "DetailTaskViewController.h"
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
    self.data = [[NSMutableArray alloc] init];
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
    textFieldFileName.placeholder = @"Número entre 1 -3";
    
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

- (void)addTaskWithTitle: (NSString*)title prioridad: (NSString *)pri {
    [self.data addObject: title];
    [self.tableView reloadData];
    
    [self saveDataToDatabase: title prioridad: pri];
}

#pragma mark - Database

- (PFQuery *)loadDataFromDatabase {
    PFQuery *query = [PFQuery queryWithClassName: @"Tarea"];
    [query whereKey:@"lista" equalTo: self.list];
    [query selectKeys: @[@"nombre"]];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *tasks, NSError *error) {
        if (tasks) {
            for (PFObject *task in tasks) {
                NSString *s = task[@"nombre"];
                [self.data addObject: s];
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

- (NSInteger)getPriorityFromTask: (NSString *)title {
    NSInteger pri;
    
    PFQuery *query = [PFQuery queryWithClassName: @"Tarea"];
    [query whereKey: @"nombre" equalTo: title];
    [query selectKeys: @[@"prioridad"]];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *tasks, NSError *error) {
        if (tasks) {
            for (PFObject *task in tasks) {
                NSInteger p = task[@"prioridad"];
                NSLog(@"%l", p);
            }
        }
    }];
    
    return 0;
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
    
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailTask"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = self.data[indexPath.row];
        
        [[segue destinationViewController] setList: self.list];
        [[segue destinationViewController] setOldTask: object];
        //[self getPriorityFromTask: object];
        //[[segue destinationViewController] setPriority: @"1"];
        [[segue destinationViewController] setDelegado: self];
    }
}

#pragma mark - Protocolo AgregarContacto

- (void) quitaVista {
    [self.navigationController popViewControllerAnimated: YES];
}

@end