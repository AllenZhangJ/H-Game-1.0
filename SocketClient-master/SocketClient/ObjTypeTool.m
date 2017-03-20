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
static NSDictionary *kTypeCatalogueDic;

@implementation ObjTypeReturnData
/** 
    returnData  value
    dataLangth  总长度
 */
+ (id)returnData:(id)returnData andDataLangth:(NSUInteger)dataLangth{
    ObjTypeReturnData *rData = [ObjTypeReturnData new];
    rData.returnData = returnData;
    rData.dataLangth = dataLangth;
    return rData;
}
@end

@implementation ObjTypeTool
//Catalogue listing
- (instancetype)init{
    if (self = [super init]) {
        if (!kTypeCatalogueDic) {
            //读取类型目录表
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CataloguelistingPlist"ofType:@"plist"];
            kTypeCatalogueDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        }
    }
    return self;
}
//Methods
+ (ObjTypeReturnData *)getValueFromData:(NSData *)data forProperty:(NSString *)property{
    BaseModelPropertyType type = [self propertyTypeOfProperty:property];
    switch (type) {
        case BaseModelPropertyType_UInt8:{
            uint8_t tmp;
            //截取对应data
            data = [data subdataWithRange:NSMakeRange(0, sizeof(uint8_t))];
            [data getBytes:&tmp length:sizeof(uint8_t)];
            return [ObjTypeReturnData returnData:[NSNumber numberWithInteger:tmp] andDataLangth:sizeof(uint8_t)];
        }
            break;
        case BaseModelPropertyType_UInt16:{
            uint16_t tmp;
            //截取对应data
            data = [data subdataWithRange:NSMakeRange(0, sizeof(uint16_t))];
            [data getBytes:&tmp length:sizeof(uint16_t)];
            return [ObjTypeReturnData returnData:[NSNumber numberWithInteger:tmp] andDataLangth:sizeof(uint16_t)];
        }
            break;
        case BaseModelPropertyType_UInt32:{
            uint32_t tmp;
            //截取对应data
            data = [data subdataWithRange:NSMakeRange(0, sizeof(uint32_t))];
            [data getBytes:&tmp length:sizeof(uint32_t)];
            return [ObjTypeReturnData returnData:[NSNumber numberWithInteger:tmp] andDataLangth:sizeof(uint32_t)];
        }
            break;
        case BaseModelPropertyType_UInt64:{
            uint64_t tmp;
            //截取对应data
            data = [data subdataWithRange:NSMakeRange(0, sizeof(uint64_t))];
            [data getBytes:&tmp length:sizeof(uint64_t)];
            return [ObjTypeReturnData returnData:[NSNumber numberWithInteger:tmp] andDataLangth:sizeof(uint64_t)];
        }
            break;
        case BaseModelPropertyType_NSString:{
            //字符长度
            NSInteger stringLength = [self langthByteNumberFormData:data];
            //截取对应data
            data = [data subdataWithRange:NSMakeRange(0, stringLength+kObjTypeToolStringHeaderLength)];
            NSData *strData = [data subdataWithRange:NSMakeRange(kObjTypeToolStringHeaderLength, stringLength)];
            return [ObjTypeReturnData returnData:[[NSString alloc]initWithData:strData encoding:NSUTF8StringEncoding] andDataLangth:stringLength+kObjTypeToolStringHeaderLength];
        }
            break;
            
        case BaseModelPropertyType_SCMapUInt8UInt16: {
            NSUInteger number = [self langthByteNumberFormData:data];
            NSUInteger mapLength = (sizeof(uint8_t) + sizeof(uint16_t))*number;
            data = [data subdataWithRange:NSMakeRange(0, mapLength+kObjTypeToolStringHeaderLength)];
            SCMapUInt8UInt16 *mapData = [[SCMapUInt8UInt16 alloc]initWithData:data];
            return [ObjTypeReturnData returnData:mapData andDataLangth:mapLength+kObjTypeToolStringHeaderLength];
        }
            break;
        default:
            return nil;
            break;
    }
}

//根据传入data
+ (NSUInteger)langthByteNumberFormData:(NSData *)data{
    if (!data || data.length < sizeof(kObjTypeToolStringHeaderLength)) {
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
    NSString *keyStr;
    // 现在只考虑 Uint32 占4个字节
    if ([property hasPrefix:@"@"]) {
        /** 
         OC类型进来有前后缀 @“xxx" 截取xxx
         */
        keyStr = [property substringWithRange:NSMakeRange(2, property.length - 3)];
    }else{
        // c 类型
        keyStr = property;
    }
    return [[kTypeCatalogueDic valueForKey:keyStr] integerValue];
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
            uint64_t tmp_64 = tmp.unsignedLongLongValue;
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
//根据传入data获得key和Velue
//+ (NSDictionary)private_ReturnDicData
//根据传入data获得数组总长度
+ (NSUInteger)private_vectorByteNumberFormData:(NSData *)data DataAllNumber:(NSUInteger )allNumber{
    NSUInteger curLocation = 0;
    if (!data || data.length < sizeof(kObjTypeToolStringHeaderLength)) {
        // 如果 data 为空 或者 不够长
        return 0;
    }
    
    for (int i=0; i<curLocation; i++) {
        uint16_t tmp;
        // 字符描述占的范围
        NSRange agreementRange = NSMakeRange(curLocation, kObjTypeToolStringHeaderLength);
        // 获取字符描述内容
        [data getBytes:&tmp range:agreementRange];
        curLocation += kObjTypeToolStringHeaderLength + tmp;
        
    }
    return curLocation;
    
}


@end
