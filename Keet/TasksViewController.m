//
//  TasksViewController.m
//  Keet
//
//  Created by José Alberto Esquivel on 4/13/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "TasksViewController.h"
#import <Parse/Parse.h>

@interface TasksViewController ()

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
    UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"New ToDo task"
                                                   message:@"Title for new task:"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Create", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        NSString* title = [alert textFieldAtIndex:0].text;
        if (title.length > 0) {
            [self addTaskWithTitle:title];
        }
    }
}

- (void)addTaskWithTitle: (NSString*)title {
    [self.data addObject: title];
    [self.tableView reloadData];
    
    [self saveDataToDatabase: title];
}

#pragma mark - Database

- (PFQuery *)loadDataFromDatabase {
    PFQuery *query = [PFQuery queryWithClassName:@"Tarea"];
    [query whereKey:@"lista" equalTo: self.lista];
    [query selectKeys: @[@"nombre"]];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *lists, NSError *error) {
        if (lists) {
            for (PFObject *list in lists) {
                NSString *s = list[@"nombre"];
                [self.data addObject: s];
                [self.tableView reloadData];
            }
        }
    }];
    
    return query;
}

- (void)saveDataToDatabase: (NSString *)title {
    PFObject *task = [PFObject objectWithClassName:@"Tarea"];
    task[@"nombre"] = title;
    task[@"creador"] = @"Eduardo";
    task[@"lista"] = self.lista;
    [task saveInBackground];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
