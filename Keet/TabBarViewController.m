//
//  TabBarViewController.m
//  Keet
//
//  Created by Eduardo Cristerna on 24/04/15.
//  Copyright (c) 2015 José Alberto Esquivel. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Primera");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: YES];
    NSLog(@"Segunda");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
