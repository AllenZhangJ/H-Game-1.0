//
//  SCServiceCenter.m
//  SocketClient
//
//  Created by you hao on 2017/3/28.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCLoginService.h"

//Delegate
#import "SCSocketDelegate.h"

//Model
#import "SCLogIn.h"
#import "SCRegistReq.h"
#import "SCMsgCenterRegistRep.h"

//Tool
#import "DataCenter.h"
#import "SCSocketCenter.h"
#import "EncryptionModel.h"

//Manager
#import "SCUserSocketManager.h"

@interface SCLoginService ()
<
    SCUserSocketManagerDelegate
>
/** Manager */
@property (nonatomic ,strong) SCUserSocketManager *manager;

/** Model */
@property (nonatomic, strong) SCLogInMsg *loginMsg;
@property (nonatomic, strong) SCMsgCenterLoginRep *msgCenterLoginRep;
@property (nonatomic, strong) SCMsgCenterAccountNtf *msgCenterAccountNtf;
@property (nonatomic ,strong) SCMsgCenterRegistRep *registRep;
@end

@implementation  SCLoginService
#pragma mark - Interface
- (void)loginServerForAccount:(NSString *)account andPasscode:(NSString *)passcode{
    SCLogIn *login = [[SCLogIn alloc]init];
    login.opType = OP_LOGIN_LOGIN_PLAYER;
    login.eRegistType = 2;
    login.sAccount = account;
    login.sChannel = @"OFFICIAL";
    login.uPasscode = [EncryptionModel forEncryptedString:passcode];
    login.ePlatform = 3;
    login.sPlatformVer = @"Windows 8";
    login.sModel = @"Windows";
    login.nGameVer = 0;
    login.sIP = @"";
    login.bAutoRegist = 0;
    login.vChannnelArg = @{};
    login.uAgreementID = OBJ_InstanceType_Login;
    
    [self.manager loginServer:login];
}

- (void)registerToServerUserName:(NSString *)account andPasscode:(NSString *)passcode{
    SCRegistReq *registReq = [SCRegistReq new];
    registReq.uOpType = OP_REGIST_TYPE_PLAYER;
    registReq.sAccount = account;
    registReq.sChannel = @"OFFICIAL";
    registReq.uPasscode = [EncryptionModel forEncryptedString:passcode];
    registReq.eRegistType = 2;
    registReq.ePlatform = 3;
    registReq.sPlatformVer = @"iPhone Simulator";
    registReq.sModel = @"iPhone";
    registReq.nGameVer = 0;
    registReq.sAnonymousAccount = @"";
    registReq.sDeviceChannel = @"";
    registReq.sIP = @"193.168.1.222";
    
    registReq.uAgreementID = OBJ_InstanceType_Login_Register;
    [self.manager registerToServer:registReq];
}

- (BOOL)connectService{
    return [self.manager connectService];
}

#pragma mark - SCUserSocketManagerDelegate
/**
 接收数据
 */
- (void)receiveModelForManagerReadData:(id)objData{
    if ([[objData class] isSubclassOfClass:[SCLogInMsg class]]){
        self.loginMsg = objData;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveForServiceType:)]) {
            [self.loginServiceDelegate
             receiveForServiceType:self.loginMsg.uOpType==1?@"登录错误":@"登录成功"];
        }
        
    }
    if([[objData class] isSubclassOfClass:[SCMsgCenterLoginRep class]]){
        self.msgCenterLoginRep = objData;
        NSLog(@"Download success!\n\
              PlayerID:%u", self.msgCenterLoginRep.uPlayerID);
        
    }
    if([[objData class] isSubclassOfClass:[SCMsgCenterAccountNtf class]]){
        self.msgCenterAccountNtf = objData;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveForServiceUName:andRights:andMoney:)]) {
            [self.loginServiceDelegate
             receiveForServiceUName:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.uPlayerID]
             
             andRights:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.nRights]
             
             andMoney:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.uMoney]];
            
        }
        
    }
    if ([[objData class] isSubclassOfClass:[MsgSecretTest class]]) {
        if ([self.loginServiceDelegate respondsToSelector:@selector(whetherOnTheServer:)]) {
            [self.loginServiceDelegate whetherOnTheServer:YES];
        }
    }
    if ([[objData class]isSubclassOfClass:[SCMsgCenterRegistRep class]]) {
        self.registRep = objData;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveForServiceRegisteredSuccessfully:)]) {
            [self.loginServiceDelegate receiveForServiceRegisteredSuccessfully:self.registRep.sAccount];
        }
    }
}

- (void)disconnectFromTheServer:(NSError *)error{
#warning 判断是否需要立刻重连
    if (!error) {
        //正常断开
        NSLog(@"[SCLoginService] In order to normal and server disconnect!");
    }else{
        NSLog(@"[SCLoginService] Abnormal disconnect the server!ERROR:%@", error.userInfo[@"NSLocalizedDescription"]);
    }
}

#pragma mark - Load
- (SCUserSocketManager *)manager{
    if (!_manager) {
        _manager = [SCUserSocketManager new];
        _manager.userManagerdelegate = self;
    }
    return _manager;
}

@end
