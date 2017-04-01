//
//  SCRegisterVC.m
//  SocketClient
//
//  Created by you hao on 2017/3/30.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCRegisterVC.h"



/** Service */
#import "SCLoginService.h"

@interface SCRegisterVC ()
<
    SCLoginServiceDelegate,
    UITextFieldDelegate
>
@property (nonatomic ,strong) SCBaseTextField *userNameTextField;

@property (nonatomic ,strong) SCBaseTextField *userPasscodeTextField;

@property (nonatomic ,strong) SCBaseTextField *confirmPasswordTextField;

@property (nonatomic ,strong) SCBaseButton *registerButton;

@property (nonatomic ,strong) SCLoginService *service;
@end

@implementation SCRegisterVC
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.userPasscodeTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self.registerButton setEnabled:YES];
    }
}

#pragma mark - SCLoginServiceDelegate
- (void)receiveForServiceRegisteredSuccessfully:(NSString *)uAccount{
    if (uAccount) {
        if (self.returnTextBlock != nil) {
            self.returnTextBlock(self.userNameTextField.text, self.userPasscodeTextField.text);
        }
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@:注册成功！",uAccount]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@:注册成功！",uAccount]];
    }
}

#pragma mark - Action

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

#pragma mark - Load

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setViews{
    [self.navigationItem setTitle:@"平台注册"];
    [self.userNameTextField setPlaceholder:@"账号"];
    [self.userPasscodeTextField setPlaceholder:@"请输入6以上的密码"];
    [self.confirmPasswordTextField setPlaceholder:@"请再次输入密码"];
    [self.registerButton setTitle:@"注册"];
}

- (SCLoginService *)service{
    if (!_service) {
        _service = [SCLoginService new];
        _service.loginServiceDelegate = self;
    }
    return _service;
}

- (SCBaseTextField *)userNameTextField{
    if (!_userNameTextField) {
        if (!_userNameTextField) {
            _userNameTextField = [[SCBaseTextField alloc]initWithTextFieldStyle:SCTextFieldStyleNone];
            [self.view addSubview:_userNameTextField];
            _userNameTextField.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.view, 100).rightSpaceToView(self.view, 50).heightIs(30);
        }
    }
    return _userNameTextField;
}

- (SCBaseTextField *)userPasscodeTextField{
    if (!_userPasscodeTextField) {
        _userPasscodeTextField = [[SCBaseTextField alloc]initWithTextFieldStyle:SCTextFieldStyleNone];
        [self.view addSubview:_userPasscodeTextField];
        _userPasscodeTextField.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.userNameTextField, 10).rightSpaceToView(self.view, 50).heightIs(30);
        /** 密码模式 */
        _userPasscodeTextField.secureTextEntry = YES;
        _userPasscodeTextField.delegate = self;
    }
    return _userPasscodeTextField;
}

- (SCBaseTextField *)confirmPasswordTextField{
    if (!_confirmPasswordTextField) {
        _confirmPasswordTextField = [[SCBaseTextField alloc]initWithTextFieldStyle:SCTextFieldStyleNone];
        [self.view addSubview:_confirmPasswordTextField];
        _confirmPasswordTextField.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.userPasscodeTextField, 10).rightSpaceToView(self.view, 50).heightIs(30);
        /** 密码模式 */
        _confirmPasswordTextField.secureTextEntry = YES;
        _confirmPasswordTextField.delegate = self;
    }
    return _confirmPasswordTextField;
}

-(SCBaseButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [[SCBaseButton alloc]initWithButtonStyle:SCButtonStyleMassToneAttune returnTouchAction:^(BOOL isHighligh) {
            
            [self.service registerToServerUserName:self.userNameTextField.text andPasscode:self.userPasscodeTextField.text];
            
        }];
        [self.view addSubview:_registerButton];
        _registerButton.sd_layout.leftSpaceToView(self.view, 50).topSpaceToView(self.confirmPasswordTextField, 20).rightSpaceToView(self.view, 50).heightRatioToView(self.view, 0.05);
        
        [_registerButton setEnabled:NO];
    }
    return _registerButton;
}

@end
