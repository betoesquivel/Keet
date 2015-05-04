//
//  ChangeFamilyTableViewCell.m
//  Keet
//
//  Created by Eduardo Cristerna on 24/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "ChangeFamilyTableViewCell.h"
#import "AppDelegate.h"

@implementation ChangeFamilyTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)changeFamily {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.family = @"Esquivel";
    
    self.selected = YES;
    [NSThread sleepForTimeInterval:0.70];
    self.selected = NO;
}

@end