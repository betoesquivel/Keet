//
//  GroupChatViewController.m
//  Keet
//
//  Created by beto on 5/3/15.
//
//

#import "GroupChatViewController.h"
#import "GroupChatViewCell.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

#define TABBAR_HEIGHT 49.0f
#define TEXTFIELD_HEIGHT 70.0f

@interface GroupChatViewController ()

@end

@implementation GroupChatViewController
@synthesize chatText;

- (void)viewDidLoad {
    [super viewDidLoad];
    chatText.delegate = self;
    chatText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    AppDelegate *appDeleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     NSString *title = [[NSString alloc] initWithFormat: @" Familia. %@", appDeleg.familia[@"nombre"]];
    self.navigationItem.title = title;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadFromDatabase:) forControlEvents:UIControlEventValueChanged];
    [self.chatTable addSubview:refreshControl];
    
    [self loadFromDatabase:refreshControl];
    
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadFromDatabase:(UIRefreshControl *)refreshControl{
    self.names = [[NSMutableArray alloc] init];
    self.date = [[NSMutableArray alloc] init];
    self.text = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"entered local database");
    PFQuery *fam = [PFQuery queryWithClassName:@"Familia"];
    NSLog(@"familias");
    PFQuery *query = [PFQuery queryWithClassName: @"Mensaje"];
    NSLog(@"mensaje");
    [query whereKey:@"familyId" equalTo: [fam getFirstObject]];
    [query orderByAscending:@"createdAt"];
    NSArray *mesages = [query findObjects];
    for(PFObject *mesage in mesages){
        NSString *s = mesage[@"UserId"];
        [self.names addObject:s];
        s = mesage[@"texto"];
        [self.text addObject:s];
        s = mesage[@"createdAt"];
        [self.date addObject:s];
        
    }
    
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
    for (int ind = 0; ind < self.names.count; ind++) {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:ind inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.chatTable cellForRowAtIndexPath:insertIndexPaths];
    [self.chatTable beginUpdates];
    [self.chatTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.chatTable endUpdates];
    [self.chatTable reloadData];
    [self.chatTable scrollsToTop];
    [refreshControl endRefreshing];
    
   
    [self.chatTable reloadData];
    
}

#pragma mark - Keyboard

- (void) quitKeyboard {
    [self.view endEditing: YES];
}

-(IBAction) textFieldDoneEditing : (id) sender
{
    NSLog(@"the text content%@",chatText.text);
    [sender resignFirstResponder];
    [chatText resignFirstResponder];
}

-(IBAction) backgroundTap:(id) sender
{
    [self.chatText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"the text content to send%@",chatText.text);
    [chatText resignFirstResponder];
    
    if (chatText.text.length>0) {
    
        NSLog(@" ENTRO A LA CONDICION");
        PFObject *newMessage = [PFObject objectWithClassName:@"Mensaje"];
        [newMessage setObject:chatText.text forKey:@"texto"]; // add text
        //NSLog(@" crea objeto tipo mensaje");
        PFQuery *checkUser = [PFQuery queryWithClassName:@"User"];
        [checkUser whereKey:@"email" equalTo:appDelegate.user];
       // NSLog(@"verifica usuario ");
        PFObject *resultUser = [checkUser getFirstObject];
        NSLog(@"exitoso usuario%@ %@ %@", resultUser,resultUser[@"familia"],resultUser[@"puntos"]);
        [newMessage setObject: resultUser forKey:@"UserID"];
        // add user sending the message
        //NSLog(@" introduce usuario");
        PFQuery *checkFamily = [PFQuery queryWithClassName:@"Familia"];
        [checkFamily whereKey:@"nombre" equalTo:appDelegate.family];
        PFObject *resultFamily = [checkFamily getFirstObject]; // add family he belongs to
        [newMessage setObject:resultFamily forKey:@"familyId"];
        //NSLog(@"introduce familia");
        //[newMessage setObject:[NSDate date] forKey:@"updatedAt"];
        //[newMessage setObject:[NSDate date] forKey:@"createdAt"]; // date in which the messague was sent;
        
        [newMessage saveInBackground];
        NSLog(@"guardo de manera exitosa");
        chatText.text = @"";
    }
    
    
    return NO;
}


-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void) freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void) keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"Keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height+TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height-TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ChatCell" forIndexPath:indexPath];
    
    cell.userLabel.text = self.names[indexPath.row];
    cell.textString.text = self.text[indexPath.row];
    cell.timeLabel.text = self.date[indexPath.row];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
