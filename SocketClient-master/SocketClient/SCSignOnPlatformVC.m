//
//  SCSignOnPlatformVC.m
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCSignOnPlatformVC.h"

/** VC */
#import "SCRegisterVC.h"

/** Service */
#import "SCLoginService.h"

@interface SCSignOnPlatformVC ()
<
    UITextFieldDelegate,
    SCLoginServiceDelegate
>
/** Setvice */
@property (nonatomic ,strong) SCLoginService *service;

/** View */
@property (nonatomic ,strong) SCBaseTextField *userNameText;

@property (nonatomic ,strong) SCBaseTextField *userPassCodeText;

@property (nonatomic ,strong) SCBaseButton *loginButton;

@property (nonatomic ,strong) SCBaseButton *registerButton;

@end

@implementation SCSignOnPlatformVC
#pragma mark - SCLoginServiceDelegate
- (void)receiveForServiceType:(NSString *)type{
    NSLog(@"type:%@", type);
}

-(void)receiveForServiceUName:(NSNumber *)uName andRights:(NSNumber *)rights andMoney:(NSNumber *)money{
    NSLog(@"uName:%@",uName);
}

#pragma mark - Action
- (void)loginPlatform{
    [self.service loginServerForAccount:self.userNameText.text andPasscode:self.userPassCodeText.text];
}

- (void)toTheRegisterVC{
    [self.navigationController pushViewController:[SCRegisterVC new] animated:YES];
}

#pragma mark - Load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setViews{
    [self.navigationItem setTitle:@"平台登录"];
    [self.userNameText setPlaceholder:@"账号"];
    [self.userPassCodeText setPlaceholder:@"密码"];
    [self.loginButton setTitle:@"登录"];
    [self.registerButton setTitle:@"注册"];
}

- (SCBaseButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [[SCBaseButton alloc]initWithButtonStyle:SCButtonStyleViceTonal];
        [self.view addSubview:_registerButton];
        _registerButton.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.loginButton, 10).widthRatioToView(self.loginButton, 0.3).heightRatioToView(self.view, 0.05);
        [_registerButton addTarget:self action:@selector(toTheRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (SCBaseButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[SCBaseButton alloc]initWithButtonStyle:SCButtonStyleMassToneAttune];
        [self.view addSubview:_loginButton];
        _loginButton.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.userPassCodeText, 20).rightSpaceToView(self.view, 50).heightRatioToView(self.view, 0.05);
        [_loginButton addTarget:self action:@selector(loginPlatform) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (SCBaseTextField *)userNameText{
    if (!_userNameText) {
        _userNameText = [[SCBaseTextField alloc]initWithTextFieldStyle:SCTextFieldStyleNone];
        [self.view addSubview:_userNameText];
        _userNameText.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.view, 100).rightSpaceToView(self.view, 50).heightIs(30);
    }
    return _userNameText;
}

- (SCBaseTextField *)userPassCodeText{
    if (!_userPassCodeText) {
        _userPassCodeText = [[SCBaseTextField alloc]initWithTextFieldStyle:SCTextFieldStyleNone];
        [self.view addSubview:_userPassCodeText];
        _userPassCodeText.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.userNameText, 10).rightSpaceToView(self.view, 50).heightIs(30);
        /** 密码模式 */
        _userPassCodeText.secureTextEntry = YES;
    }
    return _userPassCodeText;
}
- (SCLoginService *)service{
    if (!_service) {
        _service = [SCLoginService new];
        _service.loginServiceDelegate = self;
    }
    return _service;
}
@end
