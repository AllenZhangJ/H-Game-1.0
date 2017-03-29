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

//Tool
#import "DataCenter.h"
#import "SCSocketCenter.h"

@interface SCLoginService ()<SCSocketDelegate>
/** Tool */
@property (nonatomic, strong) DataCenter *dataCenter;
@property (nonatomic, strong) SCSocketCenter *socketCenter;

/** Model */
@property (nonatomic, strong) SCLogInMsg *loginMsg;
@property (nonatomic, strong) SCMsgCenterLoginRep *msgCenterLoginRep;
@property (nonatomic, strong) SCMsgCenterAccountNtf *msgCenterAccountNtf;
@end

@implementation  SCLoginService
#pragma mark - Interface
- (void)loginServerForAccount:(NSString *)account andPasscode:(NSString *)passcode{
    SCLogIn *login = [[SCLogIn alloc]init];
    login.opType = OP_LOGIN_LOGIN_PLAYER;
    login.eRegistType = 2;
    login.sAccount = account;
    login.sChannel = @"OFFICIAL";
    login.uPasscode = [NSNumber numberWithInteger:passcode.integerValue].unsignedIntValue;
    login.ePlatform = 3;
    login.sPlatformVer = @"Windows 8";
    login.sModel = @"Windows";
    login.nGameVer = 0;
    login.sIP = @"";
    login.bAutoRegist = 0;
    login.vChannnelArg = @{};
    login.uAgreementID = OBJ_InstanceType_Login;
    
    [self.socketCenter sendMessageToTheServer:login];
}
- (BOOL)connectService{
    return [self.socketCenter connectService];
}
#pragma mark - SocketData
/**
 接收数据
 */
- (void)receiveModelForServiceReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"tag:%lu", tag);
    id objModel = [self.dataCenter objFromData:data];
    if ([[objModel class] isSubclassOfClass:[SCLogInMsg class]]){
        self.loginMsg = objModel;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveForServiceType:)]) {
            [self.loginServiceDelegate
             receiveForServiceType:self.loginMsg.uOpType==1?@"登录错误":@"登录成功"];
        }
        
    }
    if([[objModel class] isSubclassOfClass:[SCMsgCenterLoginRep class]]){
        self.msgCenterLoginRep = objModel;
        NSLog(@"Download success!\n\
              PlayerID:%u", self.msgCenterLoginRep.uPlayerID);
        
    }
    if([[objModel class] isSubclassOfClass:[SCMsgCenterAccountNtf class]]){
        self.msgCenterAccountNtf = objModel;
        if ([self.loginServiceDelegate respondsToSelector:@selector(receiveForServiceUName:andRights:andMoney:)]) {
            [self.loginServiceDelegate
             receiveForServiceUName:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.uPlayerID]
             
             andRights:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.nRights]
             
             andMoney:[NSNumber numberWithUnsignedInteger:self.msgCenterAccountNtf.xAccountInfo.uMoney]];
            
        }
        
    }
    if ([[objModel class] isSubclassOfClass:[MsgSecretTest class]]) {
        if ([self.loginServiceDelegate respondsToSelector:@selector(whetherOnTheServer:)]) {
            [self.loginServiceDelegate whetherOnTheServer:YES];
        }
//        MsgSecretTest *dataTest_obj = objModel;
//        NSLog(@"tag:%lu——————receive\n\
//              ---------\n\
//              uAssID:%u,\n\
//              uScretKey:%u,\n\
//              uTimeNow:%u,\n\
//              u8Test:%d,\n\
//              u16Test:%d,\n\
//              sTest:%@,\n\
//              vU8U16Test:%@,\n\
//              vStringTest:%@,\n\
//              vStringIntTest:%@,\n\
//              vStructTest:%@\n\
//              ",
//              tag,
//              dataTest_obj.uAssID,
//              dataTest_obj.uSecretKey,
//              dataTest_obj.uTimeNow,
//              dataTest_obj.u8Test,
//              dataTest_obj.u16Test,
//              dataTest_obj.sTest,
//              dataTest_obj.vU8U16Test,
//              dataTest_obj.vStringTest,
//              dataTest_obj.vStringIntTest,
//              dataTest_obj.vStructTest
//              );
    }
}

#pragma mark - Load
- (DataCenter *)dataCenter{
    if (!_dataCenter) {
        _dataCenter = [DataCenter sharedManager];
    }
    return _dataCenter;
}
- (SCSocketCenter *)socketCenter{
    if (!_socketCenter) {
        _socketCenter = [SCSocketCenter sharedManager];
        _socketCenter.socketdelegate = self;
    }
    return _socketCenter;
}

@end
