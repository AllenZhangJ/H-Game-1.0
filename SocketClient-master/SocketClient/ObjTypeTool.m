//
//  ObjTypeTool.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "ObjTypeTool.h"
#import "SCVector.h"

static const NSUInteger kObjTypeToolStringHeaderLength = sizeof(uint16_t);

NSString *const ObjTypeToolString_UInt8 = @"C";//  UInt8对应的类型字符串
NSString *const ObjTypeToolString_UInt16 = @"S";// UInt16对应的类型字符串
NSString *const ObjTypeToolString_UInt32 = @"I";// UInt32对应的类型字符串
NSString *const ObjTypeToolString_UInt64 = @"Q";// UInt64对应的类型字符串
NSString *const ObjTypeToolString_NSString = @"@\"NSString\"";// NSString对应的类型字符串
NSString *const ObjTypeToolString_Vector = @"@\"SCVector\"";// Vector对应的类型字符串

@implementation ObjTypeTool

+ (id)getValueFromData:(NSData *)data forProperty:(NSString *)property{
    BaseModelPropertyType type = [self propertyTypeOfProperty:property];
    switch (type) {
        case BaseModelPropertyType_UInt8:{
            uint8_t tmp;
            [data getBytes:&tmp length:sizeof(uint8_t)];
            return [NSNumber numberWithInteger:tmp];
        }
            break;
        case BaseModelPropertyType_UInt16:{
            uint16_t tmp;
            [data getBytes:&tmp length:sizeof(uint16_t)];
            return [NSNumber numberWithInteger:tmp];
        }
            break;
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
            NSData *strData = [data subdataWithRange:NSMakeRange(kObjTypeToolStringHeaderLength, stringLength)];
            return [[NSString alloc]initWithData:strData encoding:NSUTF8StringEncoding];
        }
            break;
        case BaseModelPropertyType_SCVector:{
            
        }
        default:
            return nil;
            break;
    }
}

// 根据传入类型枚举值获取对应的类型所占的字节数
+ (NSUInteger)byteNumberForPropertyType:(BaseModelPropertyType)propertyType{
    switch (propertyType) {
        case BaseModelPropertyType_UInt8:{
            // 占1字节
            return sizeof(uint8_t);
        }
        case BaseModelPropertyType_UInt16:{
            // 占2字节
            return sizeof(uint16_t);
        }
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
//根据传入data
+ (NSUInteger)stringByteNumberFormData:(NSData *)data{
    if (!data || data.length < sizeof(uint32_t)) {
        // 如果 data 为空 或者 不够长
        return 0;
    }
    uint16_t tmp;
    // 字符描述占的范围
    NSRange agreementRange = NSMakeRange(0, kObjTypeToolStringHeaderLength);
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

/**
 根据传入类型字符串 获取对应的data
 */
+ (NSData *)getDataFormValue:(id)value forProperty:(NSString *)property{
    BaseModelPropertyType type = [self propertyTypeOfProperty:property];
    switch (type) {
        case BaseModelPropertyType_UInt8:{
            NSNumber *tmp = value;
            uint8_t tmp_8 = tmp.unsignedCharValue;
            return [NSData dataWithBytes:&tmp_8 length:sizeof(tmp_8)];
        }
        case BaseModelPropertyType_UInt16:{
            NSNumber *tmp = value;
            uint16_t tmp_16 = tmp.unsignedShortValue;
            return [NSData dataWithBytes:&tmp_16 length:sizeof(tmp_16)];
        }
        case BaseModelPropertyType_UInt32:
        {
            NSNumber *tmp = value;
            uint32_t tmp_32 = tmp.unsignedIntValue;
            return [NSData dataWithBytes:&tmp_32 length:sizeof(tmp_32)];
        }
            break;
        case BaseModelPropertyType_UInt64:
        {
            NSNumber *tmp = value;
            uint64_t tmp_64 = tmp.unsignedLongValue;
            return [NSData dataWithBytes:&tmp_64 length:sizeof(tmp_64)];
        }
            break;
        case BaseModelPropertyType_NSString:
        {
            NSString *tmp_str = value;
            uint16_t tmp_length = [NSNumber numberWithInteger:tmp_str.length].unsignedIntValue;
            NSMutableData *mutableData = [NSMutableData data];
            [mutableData appendData:[NSData dataWithBytes:&tmp_length length:sizeof(tmp_length)]];
            [mutableData appendData:[tmp_str dataUsingEncoding:NSUTF8StringEncoding]];
            return [mutableData mutableCopy];
        }
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark - Private
+ (BaseModelPropertyType)private_c_PropertyTypeOfProperty:(NSString *)property{
    if ([property isEqualToString:ObjTypeToolString_UInt8]) {
        return BaseModelPropertyType_UInt8;
    }
    if ([property isEqualToString:ObjTypeToolString_UInt16]) {
        return BaseModelPropertyType_UInt16;
    }
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
