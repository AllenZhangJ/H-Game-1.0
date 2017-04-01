//
//  SCMsgCenterAccountNtf.m
//  SocketClient
//
//  Created by you hao on 2017/3/27.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCMsgCenterAccountNtf.h"
static NSString *const SCMsgCenterAccountNtf_uOpType        = @"uOpType";
static NSString *const SCMsgCenterAccountNtf_xAccountInfo   = @"xAccountInfo";
static NSString *const SCMsgCenterAccountNtf_uHashCode      = @"uHashCode";

@implementation SCMsgCenterAccountNtf
-(NSDictionary *)getRegulation{
    return @
    {
    SCMsgCenterAccountNtf_uOpType:      @[ObjTypeUInt8],
    SCMsgCenterAccountNtf_xAccountInfo: @[ObjTypeXAccountInfo],
    SCMsgCenterAccountNtf_uHashCode:    @[ObjTypeUInt32],
    };
}

-(NSDictionary *)getInterfaceRegulation{
    return @
    {
        @(OBJ_InstanceType_MsgCenterAccountNtf):
        @[
          SCMsgCenterAccountNtf_uOpType,
          SCMsgCenterAccountNtf_xAccountInfo,
          SCMsgCenterAccountNtf_uHashCode,
          ]
    };
}
@end
