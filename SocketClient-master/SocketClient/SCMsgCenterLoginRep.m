//
//  MsgCenterLoginRep.m
//  SocketClient
//
//  Created by you hao on 2017/3/27.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCMsgCenterLoginRep.h"
static NSString *const SCMsgCenterLoginRep_uOpType      = @"uOpType";
static NSString *const SCMsgCenterLoginRep_uErrCode     = @"uErrCode";
static NSString *const SCMsgCenterLoginRep_uPlayerID    = @"uPlayerID";
static NSString *const SCMsgCenterLoginRep_sAccount     = @"sAccount";
static NSString *const SCMsgCenterLoginRep_uHashCode    = @"uHashCode";

@implementation SCMsgCenterLoginRep
- (NSDictionary *)getRegulation{
    return @{
             SCMsgCenterLoginRep_uOpType:   @[ObjTypeUInt8],
             SCMsgCenterLoginRep_uErrCode:  @[ObjTypeUInt16],
             SCMsgCenterLoginRep_uPlayerID: @[ObjTypeUInt32],
             SCMsgCenterLoginRep_sAccount:  @[ObjTypeNSString],
             SCMsgCenterLoginRep_uHashCode: @[ObjTypeUInt32],
             };
}
- (NSDictionary *)getInterfaceRegulation{
    return @
    {
        @(OBJ_InstanceType_MsgCenterLoginRep):
        @[
          SCMsgCenterLoginRep_uOpType,
          SCMsgCenterLoginRep_uErrCode,
          SCMsgCenterLoginRep_uPlayerID,
          SCMsgCenterLoginRep_sAccount,
          SCMsgCenterLoginRep_uHashCode,
          ]
    };
}
@end
