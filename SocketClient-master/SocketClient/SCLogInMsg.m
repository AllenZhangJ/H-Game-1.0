//
//  SCLogInMsg.m
//  SocketClient
//
//  Created by you hao on 2017/3/24.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCLogInMsg.h"
static NSString *const SCLogInMsg_uOpType       = @"uOpType";
static NSString *const getRegulation_uErrCode   = @"uErrCode";
@implementation SCLogInMsg
-(NSDictionary *)getRegulation{
    return @{
             SCLogInMsg_uOpType:    @[ObjTypeUInt8],
             getRegulation_uErrCode:@[ObjTypeUInt16],
             };
}

- (NSDictionary *)getInterfaceRegulation{
    return @
    {
        @(OBJ_InstanceType_LoginMsg):
        @[SCLogInMsg_uOpType,
          getRegulation_uErrCode,
          ]
    };
}
@end
