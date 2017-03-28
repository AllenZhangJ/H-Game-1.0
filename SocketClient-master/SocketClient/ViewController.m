//
//  ViewController.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Allen. All rights reserved.
//

#import "ViewController.h"

#import "SCLoginService.h"

/** SubModel */
#import "SCLogIn.h"
#import "SCLogInMsg.h"
#import "SCMsgCenterLoginRep.h"
#import "SCMsgCenterAccountNtf.h"
#import "Vernt.h"
#import "MsgSecret.h"
#import "MsgSecretTest.h"

@interface ViewController ()
@property (nonatomic, strong) SCLoginService *service;

@end

@implementation ViewController

#pragma mark - Action

//发送消息
- (IBAction)sendMessageAction:(id)sender {
    [self.service loginServerForAccount:@"qqqqqq" andPasscode:@"1835900736"];
}

//接收消息
- (IBAction)receiveMessageAction:(id)sender {
    
}

- (void)showMessageWithStr:(NSString *)str{
//self.showMessageTF.text = [self.showMessageTF.text stringByAppendingFormat:@"%@\n", str];
}

#pragma mark - Load
- (void)viewDidLoad {
    [super viewDidLoad];
    //1、初始化
}

- (SCLoginService *)service{
    if (!_service) {
        _service = [[SCLoginService alloc]init];
    }
    return _service;
}
@end
