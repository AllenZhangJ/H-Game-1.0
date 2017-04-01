//
//  SClogIn.m
//  SocketClient
//
//  Created by you hao on 2017/3/24.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCLogIn.h"
#include "ObjModelPropertyType.h"
static NSString *const SCLogIn_opType       = @"opType";
static NSString *const SCLogIn_eRegistType  = @"eRegistType";
static NSString *const SCLogIn_sAccount     = @"sAccount";
static NSString *const SCLogIn_sChannel     = @"sChannel";
static NSString *const SCLogIn_uPasscode    = @"uPasscode";
static NSString *const SCLogIn_ePlatform    = @"ePlatform";
static NSString *const SCLogIn_sPlatformVer = @"sPlatformVer";
static NSString *const SCLogIn_sModel       = @"sModel";
static NSString *const SCLogIn_nGameVer     = @"nGameVer";
static NSString *const SCLogIn_sIP          = @"sIP";
static NSString *const SCLogIn_bAutoRegist  = @"bAutoRegist";
static NSString *const SCLogIn_vChannnelArg = @"vChannnelArg";

@implementation SCLogIn
-(NSDictionary *)getRegulation{
    return @
    {
    SCLogIn_opType:         @[ObjTypeUInt8],
    SCLogIn_eRegistType:    @[ObjTypeUInt8],
    SCLogIn_sAccount:       @[ObjTypeNSString],
    SCLogIn_sChannel:       @[ObjTypeNSString],
    SCLogIn_uPasscode:      @[ObjTypeUInt32],
    SCLogIn_ePlatform:      @[ObjTypeUInt8],
    SCLogIn_sPlatformVer:   @[ObjTypeNSString],
    SCLogIn_sModel:         @[ObjTypeNSString],
    SCLogIn_nGameVer:       @[ObjTypeUInt16],
    SCLogIn_sIP:            @[ObjTypeNSString],
    SCLogIn_bAutoRegist:    @[ObjTypeUInt8],
    SCLogIn_vChannnelArg:   @[ObjTypeNSDictionary,ObjTypeNSString,ObjTypeNSString],
    };
}

-(NSDictionary *)getInterfaceRegulation{
    return @
    {
        @(OBJ_InstanceType_Login):
        @[SCLogIn_opType,
          SCLogIn_eRegistType,
          SCLogIn_sAccount,
          SCLogIn_sChannel,
          SCLogIn_uPasscode,
          SCLogIn_ePlatform,
          SCLogIn_sPlatformVer,
          SCLogIn_sModel,
          SCLogIn_nGameVer,
          SCLogIn_sIP,
          SCLogIn_bAutoRegist,
          SCLogIn_vChannnelArg,]
    };
}
@end
