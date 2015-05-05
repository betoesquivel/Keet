//
//  FamilyAddMembersTableViewController.m
//  Keet
//
//  Created by José Alberto Esquivel on 5/4/15.
//
//

#import "FamilyAddMembersTableViewController.h"
#import "AddMembersViewController.h"

@interface FamilyAddMembersTableViewController ()

@end

@implementation FamilyAddMembersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *title = [[NSString alloc] initWithFormat: @"Familias de %@", _appDelegate.usuario[@"username"]];
    self.navigationItem.title = title;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget: self
                            action: @selector(loadDataFromUserObject)
                  forControlEvents: UIControlEventValueChanged];
    
    [self loadDataFromUserObject];
    
}

- (void)loadDataFromUserObject {
    PFQuery *query = [PFQuery queryWithClassName:@"Familia"];
    [query whereKey:@"createdBy" equalTo:self.appDelegate.usuario];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            self.families = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
        }else{
            NSLog(@"Hubo un error!");
        }
    }];
    [self.refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.families count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[_families objectAtIndex:indexPath.row] objectForKey:@"nombre"];
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
 AddMembersViewController *vc = [segue destinationViewController];
 vc.delegate = _delegate;
 NSIndexPath *index  = [self.tableView indexPathForSelectedRow];
 vc.family = self.families[index.row];
 }
@end
