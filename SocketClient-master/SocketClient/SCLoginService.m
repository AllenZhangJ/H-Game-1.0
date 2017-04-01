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
@property (nonatomic, strong) SCRegistReq *registReq;

@end

@implementation  SCLoginService
#pragma mark - Interface
- (void)loginServerForAccount:(NSString *)account andPasscode:(NSString *)passcode{
    SCLogIn *login = [[SCLogIn alloc]initWithSendToAgreementID:OBJ_InstanceType_Login];
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
    
    [self.manager loginServer:login];
}

- (void)registerToServerUserName:(NSString *)account andPasscode:(NSString *)passcode{
    SCRegistReq *registReq = [[SCRegistReq alloc]initWithSendToAgreementID:OBJ_InstanceType_Login_Register];
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
    BaseModel *baseModel = objData;
    uint32_t agreementID = [baseModel returnAgreementID];
    
    if (agreementID == OBJ_InstanceType_LoginMsg) {
        self.loginMsg = objData;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveForServiceType:)]) {
            switch (self.loginMsg.uErrCode) {
                case 8194:{
                    [self.loginServiceDelegate receiveForServiceType:@"重复登录"];
                }
                    break;
                case 8195:{
                    [self.loginServiceDelegate receiveForServiceType:@"账号密码错误"];
                    [self.manager connectService];
                }
                    break;
                default:
                    break;
            }
        }
        return;
    }
    
    if (agreementID == OBJ_InstanceType_MsgCenterAccountNtf) {
        self.msgCenterAccountNtf = objData;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveForServiceUName:andRights:andMoney:)]) {
            [self.loginServiceDelegate
             receiveForServiceUName:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.uPlayerID]
             
             andRights:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.nRights]
             
             andMoney:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.uMoney]];
            
        }
        return;
    }
    
    if (agreementID == OBJ_InstanceType_MsgCenterLoginRep) {
        self.msgCenterLoginRep = objData;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveLoginSuccessful:andUserName:)]) {
            [self.loginServiceDelegate receiveLoginSuccessful:self.msgCenterLoginRep.uErrCode==1?YES:NO andUserName:self.msgCenterLoginRep.sAccount];
        }
        return;
    }
    
    //连接消息
    if (agreementID == OBJ_InstanceType_MsgSecretTest) {
        if ([self.loginServiceDelegate respondsToSelector:@selector(whetherOnTheServer:)]) {
            [self.loginServiceDelegate whetherOnTheServer:YES];
        }
        return;
    }
    
    //注册消息
    if (agreementID == OBJ_InstanceType_MSGCenterRegister) {
        self.registReq = objData;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveForServiceRegisteredSuccessfully:)]) {
            [self.loginServiceDelegate receiveForServiceRegisteredSuccessfully:self.registReq.sAccount];
        }
        return;
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
