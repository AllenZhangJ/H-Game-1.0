//
//  SCBaseNavigationController.m
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCBaseNavigationController.h"

@interface SCBaseNavigationController ()

@end

@implementation SCBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
