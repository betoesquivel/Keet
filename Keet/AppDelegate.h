//
//  AppDelegate.h
//  Keet
//
//  Created by José Alberto Esquivel on 4/13/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *family;

@property (strong, nonatomic) NSString *user;

@property (strong, nonatomic) PFObject *usuario;
@property (strong, nonatomic) PFObject *familia;
@property (strong, nonatomic) NSArray *familias;
@end