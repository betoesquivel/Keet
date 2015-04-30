//
//  ListsViewController.m
//  Keet
//
//  Created by José Alberto Esquivel on 4/13/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "ListsViewController.h"
#import "TasksViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface ListsViewController ()

@end

@implementation ListsViewController

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    NSString *title = [[NSString alloc] initWithFormat: @"Fam. %@", appDelegate.family];
    self.navigationItem.title = title;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget: self
                            action: @selector(loadDataFromDatabase)
                  forControlEvents: UIControlEventValueChanged];
    
    [self.navigationController.navigationBar setBarTintColor: UIColorFromRGB(0xDADADA)];
    
    [self loadDataFromDatabase];
}

- (void)viewDidAppear:(BOOL)animated {
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create List

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
        
        if (title.length > 0)
            [self addListWithTitle:title];
    }
}

- (void)addListWithTitle: (NSString*)title {
    [self.data addObject: title];
    
    [self.tableView reloadData];
    
    [self saveDataToDatabase: title];
}

#pragma mark - Database

- (void)loadDataFromDatabase {
    self.data = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PFQuery *query = [PFQuery queryWithClassName: @"Lista"];
    [query selectKeys: @[@"nombre"]];
    [query whereKey: @"familia" equalTo: appDelegate.family];
    [query orderByAscending: @"nombre"];
    NSArray *lists = [query findObjects];
    
    for (PFObject *list in lists) {
        NSString *s = list[@"nombre"];
        [self.data addObject: s];
    }
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)saveDataToDatabase: (NSString *)title {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    PFObject *list = [PFObject objectWithClassName: @"Lista"];
    list[@"nombre"] = title;
    list[@"creador"] = appDelegate.user;
    list[@"familia"] = appDelegate.family;
    
    [list saveInBackground];
}

- (void)deleteDataFromDatabase: (NSString *) title {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PFQuery *query = [PFQuery queryWithClassName: @"Tarea"];
    [query whereKey: @"lista" equalTo: title];
    [query whereKey: @"familia" equalTo: appDelegate.family];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *tasks, NSError *error) {
        if (tasks) {
            for (PFObject *task in tasks) {
                [task deleteInBackground];
            }
        }
    }];
    
    query = [PFQuery queryWithClassName: @"Lista"];
    [query whereKey: @"nombre" equalTo: title];
    [query whereKey: @"familia" equalTo: appDelegate.family];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"taskSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = self.data[indexPath.row];
        [[segue destinationViewController] setList:object];
    }
 }

@end