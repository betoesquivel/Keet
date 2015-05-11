//
//  MembersTableViewController.m
//  Keet
//
//  Created by Eduardo Cristerna on 24/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "MembersTableViewController.h"
#import "MemberContactTableViewCell.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface MembersTableViewController ()

@end

@implementation MembersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *title = [[NSString alloc] initWithFormat: @"Miembros Fam. %@", appDelegate.familia[@"nombre"]];
    self.navigationItem.title = title;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget: self
                            action: @selector(loadDataFromDatabase)
                  forControlEvents: UIControlEventValueChanged];
    
    [self loadDataFromDatabase];
}

- (void)viewDidAppear:(BOOL)animated {
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Database

- (void)loadDataFromDatabase {
    self.names = [[NSMutableArray alloc] init];
    self.emails = [[NSMutableArray alloc] init];
    self.points = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PFQuery *query = [PFQuery queryWithClassName: @"User"];
    [query whereKey:@"familias" equalTo: appDelegate.familia];
    [query includeKey:@"familias"];
/*
    [query selectKeys: @[@"username", @"email", @"puntos"]];
    [query whereKey: @"familia" equalTo: appDelegate.family];
 */
    [query orderByAscending: @"username"];
    
    NSArray *members = [query findObjects];
    
    for (PFObject *member in members) {
        NSString *s = member[@"username"];
        [self.names addObject: s];
        s = member[@"email"];
        [self.emails addObject: s];
        s = member[@"puntos"];
        [self.points addObject: s];
    }
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MemberCell" forIndexPath:indexPath];
    
    cell.lblName.text = self.names[indexPath.row];
    cell.lblEmail.text = self.emails[indexPath.row];
    cell.lblPoints.text = self.points[indexPath.row];
    
    return cell;
}

@end