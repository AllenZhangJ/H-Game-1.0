//
//  ObjTypeTool.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "ObjTypeTool.h"

NSString *const ObjTypeToolString_UInt32 = @"I";// UInt32对应的类型字符串
NSString *const ObjTypeToolString_UInt64 = @"Q";// UInt64对应的类型字符串
NSString *const ObjTypeToolString_NSString = @"@\"NSString\"";// NSString对应的类型字符串


@implementation ObjTypeTool

+ (id)getValueFromData:(NSData *)data forProperty:(NSString *)property{
    BaseModelPropertyType type = [self propertyTypeOfProperty:property];
    switch (type) {
        case BaseModelPropertyType_UInt32:{
            uint32_t tmp;
            [data getBytes:&tmp length:sizeof(uint32_t)];
            return [NSNumber numberWithUnsignedInteger:tmp];
        }
            break;
            
        case BaseModelPropertyType_UInt64:{
            uint64_t tmp;
            [data getBytes:&tmp length:sizeof(uint64_t)];
            return [NSNumber numberWithUnsignedInteger:tmp];
        }
            break;
        case BaseModelPropertyType_NSString:{
            NSInteger stringLength = [self stringByteNumberFormData:data];
            NSData *strData = [data subdataWithRange:NSMakeRange(sizeof(uint32_t), stringLength)];
            return [[NSString string]initWithData:strData encoding:NSUTF8StringEncoding];
        }
            break;
        default:
            return nil;
            break;
    }
}

// 根据传入类型枚举值获取对应的类型所占的字节数
+ (NSUInteger)byteNumberForPropertyType:(BaseModelPropertyType)propertyType{
    switch (propertyType) {
        case BaseModelPropertyType_UInt32:{
            // 占4字节
            return sizeof(uint32_t);
        }
            break;
            
        case BaseModelPropertyType_UInt64:{
            // 占8字节
            return sizeof(uint64_t);
        }
            break;
        default:
            // 默认0字节
            return 0;
            break;
    }
}

+ (NSUInteger)stringByteNumberFormData:(NSData *)data{
    uint32_t tmp;
    // 字符描述占的范围
    NSRange agreementRange = NSMakeRange(0, sizeof(uint32_t));
    // 获取字符描述内容
    [data getBytes:&tmp range:agreementRange];
    return tmp;
}

// 根据传入类型字符串获取对应的枚举值
+ (BaseModelPropertyType)propertyTypeOfProperty:(NSString *)property{
    // 现在只考虑 Uint32 占4个字节
    if ([property hasPrefix:@"@"]) {
        // oc 类型
        return [self private_oc_PropertyTypeOfProperty:property];
    }else{
        // c 类型
        return [self private_c_PropertyTypeOfProperty:property];
    }
}

#pragma mark - Private
+ (BaseModelPropertyType)private_c_PropertyTypeOfProperty:(NSString *)property{
    if ([property isEqualToString:ObjTypeToolString_UInt32]) {
        return BaseModelPropertyType_UInt32;
    }
    if ([property isEqualToString:ObjTypeToolString_UInt64]) {
        return BaseModelPropertyType_UInt64;
    }
    if ([property isEqualToString:ObjTypeToolString_NSString]) {
        return BaseModelPropertyType_NSString;
    }
    return BaseModelPropertyType_Error;
}

+ (BaseModelPropertyType)private_oc_PropertyTypeOfProperty:(NSString *)property{
    if ([property isEqualToString:ObjTypeToolString_NSString]) {
        return BaseModelPropertyType_NSString;
    }
    return BaseModelPropertyType_Error;
}

@end
