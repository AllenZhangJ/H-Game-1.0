//
//  MsgSecretTest.m
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "MsgSecretTest.h"
#import "ObjSerializerTool.h"
static NSString *const MsgSecretTest_uAssID         = @"uAssID";
static NSString *const MsgSecretTest_uSecretKey     = @"uSecretKey";
static NSString *const MsgSecretTest_uTimeNow       = @"uTimeNow";

@implementation MsgSecretTest
- (NSDictionary *)getRegulation{
    return @{
             MsgSecretTest_uAssID:      @[ObjTypeUInt32],
             MsgSecretTest_uSecretKey:  @[ObjTypeUInt32],
             MsgSecretTest_uTimeNow:    @[ObjTypeUInt32],
             };
}

- (NSDictionary *)getInterfaceRegulation{
    return @
    {
        @(OBJ_InstanceType_MsgSecretTest):
        @[MsgSecretTest_uAssID,
          MsgSecretTest_uSecretKey,
          MsgSecretTest_uTimeNow,
          ]
    };
}
@end
