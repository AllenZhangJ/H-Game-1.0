//
//  MsgSecretTest.m
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "MsgSecretTest.h"
#import "ObjSerializerTool.h"

@implementation MsgSecretTest
- (NSDictionary *)getRegulation{
    return @{
             @"vU8U16Test":@[@"NSDictionary",ObjTypeUInt8,ObjTypeUInt16],
             @"vStringTest":@[@"NSArray",ObjTypeNSString],
             @"vStringIntTest":@[@"NSDictionary",ObjTypeNSString,ObjTypeUInt32],
             @"vStructTest":@[@"NSDictionary", ObjTypeUInt32,ObjTypeXTest],
             };
}
@end
