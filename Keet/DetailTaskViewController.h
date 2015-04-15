//
//  DetailTaskViewController.h
//  Keet
//
//  Created by Eduardo Cristerna on 15/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProtocolDetailTask <NSObject>

- (void) agregaContacto: (NSString *)nombre withOficina: (NSString *) ofic withTelefono: (NSInteger)tel;
- (void) quitaVista;

@end

@interface DetailTaskViewController : UIViewController

@property (strong, nonatomic) id <ProtocolDetailTask> delegado;

@property (strong, nonatomic) NSString *list;

@property (strong, nonatomic) NSString *task;

@property (strong, nonatomic) NSString *oldTask;

@property (strong, nonatomic) NSString *priority;

@property (weak, nonatomic) IBOutlet UITextField *txtList;

@property (weak, nonatomic) IBOutlet UITextField *txtTask;

@property (weak, nonatomic) IBOutlet UISegmentedControl *btnPriority;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)save:(id)sender;

- (IBAction)delete:(id)sender;

@end