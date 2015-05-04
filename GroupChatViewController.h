//
//  GroupChatViewController.h
//  Keet
//
//  Created by beto on 5/3/15.
//
//

#import <UIKit/UIKit.h>

@interface GroupChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *chatTable;

@property (weak, nonatomic) IBOutlet UITextField *chatText;
@property (strong,nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableArray *date;
@property (strong, nonatomic) NSMutableArray *text;
@property (nonatomic, retain) NSArray *chatData;

@end
