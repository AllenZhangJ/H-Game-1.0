//
//  Vernt.m
//  SocketClient
//
//  Created by Allen on 2017/3/14.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "Vernt.h"

@implementation Vernt
- (NSDictionary *)getRegulation{
    return @{
             @"vID_16":@[ObjTypeUInt16],
             @"vID_DDDictionary":@[ObjTypeNSDictionary,ObjTypeUInt8,ObjTypeNSDictionary],
             @"vID_array":@[@"NSArray",ObjTypeNSString],
             @"vID_Dictionary":@[@"NSDictionary",ObjTypeUInt16,ObjTypeNSString],
             };
}
- (NSDictionary *)getInterfaceRegulation{
    return @{
             @(OBJ_InstanceType_MsgSecretTest):@[@"vID_16", @"vID_64", @"vID_Dictionary"],
             };
}
@end
