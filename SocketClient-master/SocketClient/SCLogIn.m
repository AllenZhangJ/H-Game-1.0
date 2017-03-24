//
//  SClogIn.m
//  SocketClient
//
//  Created by you hao on 2017/3/24.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCLogIn.h"
#include "ObjModelPropertyType.h"
@implementation SCLogIn
-(NSDictionary *)getRegulation{
    return @{
             @"vChannnelArg":@[@"NSDictionary",ObjTypeNSString,ObjTypeNSString],
             };
}
@end
