//
//  ListsViewController.m
//  Keet
//
//  Created by José Alberto Esquivel on 4/13/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "ListsViewController.h"
#import "TasksViewController.h"
#import <Parse/Parse.h>

@interface ListsViewController ()

@end

@implementation ListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Listas";
    
    [self loadDataFromDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - New List

- (IBAction)addButtonAction:(id)sender {
    UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"Nueva Lista de Tareas"
                                                   message:@"Nombre de la Lista"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancelar"
                                         otherButtonTitles:@"Crear", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        NSString* title = [alert textFieldAtIndex:0].text;
        if (title.length > 0) {
            [self addListWithTitle:title];
        }
    }
}

- (void)addListWithTitle: (NSString*)title {
    [self.data addObject: title];
    [self.tableView reloadData];
    
    [self saveDataToDatabase: title];
}

#pragma mark - Database

- (PFQuery *)loadDataFromDatabase {
    self.data = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName: @"Lista"];
    [query selectKeys: @[@"nombre"]];
    [query orderByAscending: @"nombre"];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *lists, NSError *error) {
        for (PFObject *list in lists) {
            NSString *s = list[@"nombre"];
            [self.data addObject: s];
            [self.tableView reloadData];
        }
    }];
    
    return query;
}

- (void)saveDataToDatabase: (NSString *)title {
    PFObject *list = [PFObject objectWithClassName: @"Lista"];
    list[@"nombre"] = title;
    list[@"creador"] = @"Eduardo";
    [list saveInBackground];
}

- (void)deleteDataFromDatabase: (NSString *) title {
    PFQuery *query = [PFQuery queryWithClassName: @"Tarea"];
    [query whereKey: @"lista" equalTo: title];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *lists, NSError *error) {
        if (lists) {
            for (PFObject *list in lists) {
                [list deleteInBackground];
            }
        }
    }];
    
    query = [PFQuery queryWithClassName: @"Lista"];
    [query whereKey: @"nombre" equalTo: title];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *lists, NSError *error) {
        if (lists) {
            for (PFObject *list in lists) {
                [list deleteInBackground];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *listTitle = self.data[indexPath.row];
        [self.data removeObjectAtIndex: indexPath.row];
        [self.tableView reloadData];
        [self deleteDataFromDatabase: listTitle];
    }
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"taskSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = self.data[indexPath.row];
        [[segue destinationViewController] setList:object];
    }
 }

@end
