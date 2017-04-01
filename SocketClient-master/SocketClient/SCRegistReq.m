//
//  SCRegistReq.m
//  SocketClient
//
//  Created by you hao on 2017/3/30.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCRegistReq.h"
static NSString *const SCRegistReq_uOpType              = @"uOpType";
static NSString *const SCRegistReq_sAccount             = @"sAccount";
static NSString *const SCRegistReq_sChannel             = @"sChannel";
static NSString *const SCRegistReq_uPasscode            = @"uPasscode";
static NSString *const SCRegistReq_eRegistType          = @"eRegistType";
static NSString *const SCRegistReq_ePlatform            = @"ePlatform";
static NSString *const SCRegistReq_sPlatformVer         = @"sPlatformVer";
static NSString *const SCRegistReq_sModel               = @"sModel";
static NSString *const SCRegistReq_nGameVer             = @"nGameVer";
static NSString *const SCRegistReq_sAnonymousAccount    = @"sAnonymousAccount";
static NSString *const SCRegistReq_sDeviceChannel       = @"sDeviceChannel";
static NSString *const SCRegistReq_sIP                  = @"sIP";
static NSString *const SCRegistReq_uErrCode             = @"uErrCode";
static NSString *const SCRegistReq_uPlayerID            = @"uPlayerID";
static NSString *const SCRegistReq_sNewAccount          = @"sNewAccount";
static NSString *const SCRegistReq_uNewPasscode         = @"uNewPasscode";
static NSString *const SCRegistReq_nServerID            = @"nServerID";
static NSString *const SCRegistReq_uRights              = @"uRights";
static NSString *const SCRegistReq_bAutoRegist          = @"bAutoRegist";

@implementation SCRegistReq
- (NSDictionary *)getRegulation{
    return @{
             SCRegistReq_uOpType:           @[ObjTypeUInt8],
             SCRegistReq_sAccount:          @[ObjTypeNSString],
             SCRegistReq_sChannel:          @[ObjTypeNSString],
             SCRegistReq_uPasscode:         @[ObjTypeUInt32],
             SCRegistReq_eRegistType:       @[ObjTypeUInt8],
             SCRegistReq_ePlatform:         @[ObjTypeUInt8],
             SCRegistReq_sPlatformVer:      @[ObjTypeNSString],
             SCRegistReq_sModel:            @[ObjTypeNSString],
             SCRegistReq_nGameVer:          @[ObjTypeUInt16],
             SCRegistReq_sAnonymousAccount: @[ObjTypeNSString],
             SCRegistReq_sDeviceChannel:    @[ObjTypeNSString],
             SCRegistReq_sIP:               @[ObjTypeNSString],
             SCRegistReq_uErrCode:          @[ObjTypeUInt16],
             SCRegistReq_uPlayerID:         @[ObjTypeUInt32],
             SCRegistReq_sNewAccount:       @[ObjTypeNSString],
             SCRegistReq_uNewPasscode:      @[ObjTypeUInt32],
             SCRegistReq_nServerID:         @[ObjTypeUInt8],
             SCRegistReq_uRights:           @[ObjTypeUInt32],
             SCRegistReq_bAutoRegist:       @[ObjTypeUInt8],
             };
}

- (NSDictionary *)getInterfaceRegulation{
    return @{
             @(OBJ_InstanceType_Login_Register):@[
                     SCRegistReq_uOpType,
                     SCRegistReq_sAccount,
                     SCRegistReq_sChannel,
                     SCRegistReq_uPasscode,
                     SCRegistReq_eRegistType,
                     SCRegistReq_ePlatform,
                     SCRegistReq_sPlatformVer,
                     SCRegistReq_sModel,
                     SCRegistReq_nGameVer,
                     SCRegistReq_sAnonymousAccount,
                     SCRegistReq_sDeviceChannel,
                     SCRegistReq_sIP
                     ],
             @(OBJ_InstanceType_MSGCenterRegister):@[
                     SCRegistReq_uOpType,
                     SCRegistReq_uErrCode,
                     SCRegistReq_uPlayerID,
                     SCRegistReq_eRegistType,
                     SCRegistReq_sAccount,
                     SCRegistReq_sChannel,
                     SCRegistReq_uPasscode,
                     SCRegistReq_ePlatform,
                     SCRegistReq_sPlatformVer,
                     SCRegistReq_sModel,
                     SCRegistReq_nGameVer,
                     SCRegistReq_sIP,
                     SCRegistReq_sNewAccount,
                     SCRegistReq_uNewPasscode
                     ]
             };
}
@end
