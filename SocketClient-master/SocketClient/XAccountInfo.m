//
//  XAccountInfo.m
//  SocketClient
//
//  Created by you hao on 2017/3/27.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "XAccountInfo.h"
static NSString *const XAccountInfo_uPlayerID = @"uPlayerID";
static NSString *const XAccountInfo_nRights = @"nRights";
static NSString *const XAccountInfo_uMoney = @"uMoney";
static NSString *const XAccountInfo_uProcessTime = @"uProcessTime";

@implementation XAccountInfo
-(NSDictionary *)getRegulation{
    return @{
             XAccountInfo_uPlayerID:    @[ObjTypeUInt32],
             XAccountInfo_nRights:      @[ObjTypeUInt8],
             XAccountInfo_uMoney:       @[ObjTypeUInt32],
             XAccountInfo_uProcessTime: @[ObjTypeUInt64],
             };
}

-(NSDictionary *)getInterfaceRegulation{
    return @{
             @(OBJ_InstanceType_MsgCenterAccountNtf):
                 @[XAccountInfo_uPlayerID,
                   XAccountInfo_nRights,
                   XAccountInfo_uMoney,
                   XAccountInfo_uProcessTime
                   ]
             };
}
@end
