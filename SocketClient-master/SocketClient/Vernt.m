//
//  Vernt.m
//  SocketClient
//
//  Created by Allen on 2017/3/14.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "Vernt.h"
#import "ObjModelPropertyType.h"
@implementation Vernt
- (NSDictionary *)getRegulation{
    return @{
             @"vID_array":@[@"NSArray",ObjTypeNSString],
             @"vID_Dictionary":@[@"NSDictionary",ObjTypeUInt16,ObjTypeNSString],
             };
}
@end
