//
//  SCLoginVC.m
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCLoginVC.h"

/** VC */
#import "SCSignOnPlatformVC.h"

/** Service */
#import "SCLoginService.h"

@interface SCLoginVC ()
<
    SCLoginServiceDelegate
>
{
    BOOL isFirstConnection;
}
@property (nonatomic, strong) SCLoginService *service;
/** View */
@property (nonatomic, strong) SCBaseLabel *logoLabel;
@property (nonatomic, strong) SCBaseButton *signOnPlatformButton;
@property (nonatomic, strong) UIProgressView *myProgressView;
@property (nonatomic, strong) SCBaseLabel *myProgressTypeView;
@end

@implementation SCLoginVC

#pragma mark - SCLoginServiceDelegate
- (void)whetherOnTheServer:(BOOL)isOnTheServer{
    if (isOnTheServer) {
        [self.myProgressView setProgress:1 animated:YES];
        [self.myProgressTypeView setText:@"连上服务器"];
        [self.signOnPlatformButton setHidden:NO];
        
        if (isFirstConnection) {
            [SVProgressHUD showSuccessWithStatus:@"已连接"];
            isFirstConnection = !isFirstConnection;
        }
    }
}

#pragma mark - Action
//发送消息
- (IBAction)sendMessageAction:(id)sender {
    [self.service loginServerForAccount:@"qqqqqq" andPasscode:@"1835900736"];
}

#pragma mark - Load
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.service connectService]) {
        [self.myProgressTypeView setText:@"开始连接"];
        isFirstConnection = YES;
        NSLog(@"[Login] To connect to the server success");
    }else{
#warning 重连
        [self.myProgressTypeView setText:@"无法连接"];
        NSLog(@"[Login] Failed to connect to server");
    }
}

- (void)setViews{
    [self.logoLabel setText:@"LOGO"];
    [self.signOnPlatformButton setTitle:@"平台登录"];
    [self.myProgressView setProgress:0.1 animated:YES];
    [self.myProgressTypeView setText:@"正在连接服务器"];
}

- (SCBaseLabel *)myProgressTypeView{
    if (!_myProgressTypeView) {
        _myProgressTypeView = [[SCBaseLabel alloc]initWithLabelStyle:LabelStyleH3];
        [self.view addSubview:_myProgressTypeView];
        _myProgressTypeView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.myProgressView, 5).autoHeightRatio(0);
    }
    return _myProgressTypeView;
}
- (UIProgressView *)myProgressView{
    if (!_myProgressView) {
        _myProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.view addSubview:_myProgressView];
        _myProgressView.sd_layout.bottomSpaceToView(self.view, 5).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0);
    }
    return _myProgressView;
}
- (SCBaseLabel *)logoLabel{
    if (!_logoLabel) {
        _logoLabel = [[SCBaseLabel alloc]initWithLabelStyle:LabelStyleH1];
        [self.view addSubview:_logoLabel];
        [_logoLabel setTextColor:[UIColor redColor]];
        _logoLabel.sd_layout.topSpaceToView(self.view, 100).leftSpaceToView(self.view, 100).rightSpaceToView(self.view, 100);
    }
    return _logoLabel;
}
- (SCBaseButton *)signOnPlatformButton{
    if (!_signOnPlatformButton) {
        _signOnPlatformButton = [[SCBaseButton alloc]initWithButtonStyle:SCButtonStyleMassToneAttune returnTouchAction:^(BOOL isHighligh) {
            [self.navigationController pushViewController:[SCSignOnPlatformVC new] animated:YES];
        }];
        [self.view addSubview:_signOnPlatformButton];
        _signOnPlatformButton.sd_layout.leftSpaceToView(self.view, 50).rightSpaceToView(self.view, 50).bottomSpaceToView(self.view, 100).heightRatioToView(self.view, 0.05);
        [_signOnPlatformButton setHidden:YES];
        
    }
    return _signOnPlatformButton;
}
- (SCLoginService *)service{
    if (!_service) {
        _service = [[SCLoginService alloc]init];
        _service.loginServiceDelegate = self;
    }
    return _service;
}

@end
