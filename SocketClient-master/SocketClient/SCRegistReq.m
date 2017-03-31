//
//  SCRegistReq.m
//  SocketClient
//
//  Created by you hao on 2017/3/30.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCRegistReq.h"

@implementation SCRegistReq
- (NSDictionary *)getRegulation{
    return @{
             @"uOpType":@[ObjTypeUInt8],
             @"sAccount":@[ObjTypeNSString],
             @"sChannel":@[ObjTypeNSString],
             @"uPasscode":@[ObjTypeUInt32],
             @"eRegistType":@[ObjTypeUInt8],
             @"ePlatform":@[ObjTypeUInt8],
             @"sPlatformVer":@[ObjTypeNSString],
             @"sModel":@[ObjTypeNSString],
             @"nGameVer":@[ObjTypeUInt16],
             @"sAnonymousAccount":@[ObjTypeNSString],
             @"sDeviceChannel":@[ObjTypeNSString],
             @"sIP":@[ObjTypeNSString],
             };
}

- (NSDictionary *)getInterfaceRegulation{
    return @{
             @(OBJ_InstanceType_Login_Register):@[
                     @"uOpType",
                     @"sAccount",
                     @"sChannel",
                     @"uPasscode",
                     @"eRegistType",
                     @"ePlatform",
                     @"sPlatformVer",
                     @"sModel",
                     @"nGameVer",
                     @"sAnonymousAccount",
                     @"sDeviceChannel",
                     @"sIP"
                     ]
      };
}
@end
