//
//  SCSignOnPlatformVC.m
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCSignOnPlatformVC.h"

@interface SCSignOnPlatformVC ()<UITextFieldDelegate>

@property (nonatomic ,strong) SCBaseTextField *userNameText;

@property (nonatomic ,strong) SCBaseTextField *userPassCodeText;

@end

@implementation SCSignOnPlatformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setViews{
    [self.navigationItem setTitle:@"平台登录"];
}
- (SCBaseTextField *)userNameText{
    if (!_userNameText) {
        _userNameText = [SCBaseTextField new];
        [self.view addSubview:_userNameText];
        _userNameText.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.view, 50).rightSpaceToView(self.view, 50).heightIs(80);
    }
    return _userNameText;
}

@end
