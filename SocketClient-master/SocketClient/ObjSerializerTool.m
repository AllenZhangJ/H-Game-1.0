//
//  ObjSerializerTool.m
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "ObjSerializerTool.h"

#include "ObjModelPropertyType.h"

#import "XTest.h"

static const NSUInteger kObjTypeToolStringHeaderLength = sizeof(uint16_t);
static NSDictionary *kTypeCatalogueDic;

///////////////////////////////////////////////////////////////////////////

                    /* ObjTypeReturnData */

///////////////////////////////////////////////////////////////////////////

@implementation ObjTypeReturnData
+ (id)returnData:(id)returnData andDataLangth:(NSUInteger)dataLangth{
    ObjTypeReturnData *rData = [ObjTypeReturnData new];
    rData.returnData = returnData;
    rData.dataLangth = dataLangth;
    return rData;
}
@end

///////////////////////////////////////////////////////////////////////////

                    /* ObjSerializerTool */

///////////////////////////////////////////////////////////////////////////

@interface ObjSerializerTool(){
    NSUInteger _curLocation;// 记录当前解析的位置
}

@property (nonatomic, copy) NSMutableData *appendedData;

@end

@implementation ObjSerializerTool

#pragma mark - Interface
- (BOOL)hasNext{
    if (_objData.length > _curLocation) {
        return YES;
    }
    return NO;
}

- (id)nextValueWithType:(const char *)propertyType andRegulation:(NSArray *)regulation{
    return [self private_valueForPropertyType:propertyType andRegulation:regulation];
}

- (BOOL)appendDataForValue:(id)value andType:(const char *)propertyType andRegulation:(NSArray *)regulation{
    
    NSData *dataTmp = [self private_valueJoinDataAtValue:value
                                                 andType:propertyType andRegulation:regulation];
    if (!dataTmp || dataTmp.length == 0) {
        // 为空,或者长度为0
        return NO;
    }
    [self.appendedData appendData:dataTmp];
    
    return YES;
}
//得到长度
- (NSUInteger )getLength{
    return _curLocation;
}
#pragma mark - Private

///** 序列化 拼接 */
- (NSData *)private_valueJoinDataAtValue:(id)value andType:(const char *)propertyType andRegulation:(NSArray *)regulation{
    //判断为空
    if (!value) {
        return nil;
    }
    
    NSString *typeString =  [NSString stringWithCString:propertyType
                                               encoding:NSUTF8StringEncoding];
    
    //判断类型字符串为空
    if (!typeString
        || typeString.length == 0
        || [typeString isEqual:[NSNull null]]
        || [typeString isEqualToString:@""]) {
        return nil;
    }
    
    //拼接
    NSData *valueData = [ObjTypeTool getDataFormValue:value forProperty:typeString andRegulation:regulation];
    
    //验证
    if (!valueData) {
        //值为空
        return nil;
    }
    return valueData;
}

/** 反序列化 获得Value */
- (id)private_valueForPropertyType:(const char *)propertyType andRegulation:(NSArray *)regulation{
    if (!_objData) {
        // 如果 data 缓存为空
        return nil;
    }
    
    NSString *stringType =  [NSString stringWithCString:propertyType
                                               encoding:NSUTF8StringEncoding];
    // 获取类型
    BaseModelPropertyType type = [ObjTypeTool propertyTypeOfProperty:stringType];
        
    ObjTypeReturnData *returnData = [ObjTypeTool getValueFromData:[_objData subdataWithRange:NSMakeRange(_curLocation, _objData.length-_curLocation)] forProperty:stringType andRegulation:regulation];
    
    if (!returnData.returnData) {
        // 值为空
        return nil;
    }
    
    NSUInteger typeLangth = returnData.dataLangth;

    // 验证 Range 越界
    if (_curLocation + typeLangth > _objData.length) {
        // 越界
        return nil;
    }
    
    // 更新位置
    _curLocation += typeLangth;
    
    return returnData.returnData;
}

#pragma mark - Getters
- (NSData *)objData{
    if (!_appendedData || _appendedData.length == 0) {
        // 为空,或者长度为0
        return nil;
    }
    return [_appendedData copy];
}

#pragma mark - LazyLoad
- (NSMutableData *)appendedData{
    if (!_appendedData) {
        _appendedData = [NSMutableData data];
    }
    return _appendedData;
}

@end

///////////////////////////////////////////////////////////////////////////

                            /* ObjTypeTool */

///////////////////////////////////////////////////////////////////////////

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
+ (ObjTypeReturnData *)getValueFromData:(NSData *)data forProperty:(NSString *)property  andRegulation:(NSArray *)regulation{
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
        case BaseModelPropertyType_NSDictionary:{
            return [ObjContainerTool getDicValueFromData:data forProperty:property andRegulation:regulation];
        }
            break;
        case BaseModelPropertyType_NSArray:{
            return [ObjContainerTool getArrayValueFromData:data forProperty:property andRegulation:regulation];
        }
            break;
        case BaseModelPropertyType_XTest:{
            XTest *xTestData = [[XTest alloc]reserializeObj:data];
            return [ObjTypeReturnData returnData:xTestData andDataLangth:[xTestData returnModelLength]];
        }
            break;
        default:
            return nil;
            break;
    }
}

//根据传入data
+ (NSUInteger)langthByteNumberFormData:(NSData *)data{
//    if (!data || data.length <= sizeof(kObjTypeToolStringHeaderLength)) {
//        // 如果 data 为空 或者 不够长
//        return 0;
//    }
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
 根据传入类型字符串 获取对应的data 序列化  
 */
+ (NSData *)getDataFormValue:(id)value forProperty:(NSString *)property andRegulation:(NSArray *)regulation{
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
        case BaseModelPropertyType_NSArray:{
            NSArray *tmp_array = value;
            return [ObjContainerTool getDataForArrya:tmp_array andRegulation:regulation];
        }
            break;
        case BaseModelPropertyType_NSDictionary:{
            NSDictionary *tmp_dic = value;
            return [ObjContainerTool getDataForDictionary:tmp_dic andRegulation:regulation];
        }
            break;
        default:
            break;
    }
    return nil;
}


#pragma mark - Private
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

///////////////////////////////////////////////////////////////////////////

    /* ObjContainerTool */

///////////////////////////////////////////////////////////////////////////
@interface ObjContainerTool (){
    NSUInteger _curLocation;// 记录当前解析的位置
}

@property (nonatomic, copy) NSMutableData *appendedData;

@end

@implementation ObjContainerTool
+ (ObjTypeReturnData *)getDicValueFromData:(NSData *)data forProperty:(NSString *)property andRegulation:(NSArray *)regulation{
    if (!data) {
        // 如果 data 缓存为空
        return nil;
    }
    //个数
    NSUInteger number = [ObjTypeTool langthByteNumberFormData:data];
    //起始位置
    NSUInteger curLocation = sizeof(uint16_t);
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    for (int ergodicLocation = 0; ergodicLocation < number; ergodicLocation++) {
        //获得类型
        NSString *keyType =  regulation[1];
        
        ObjTypeReturnData *keyData = [ObjTypeTool getValueFromData:[data subdataWithRange:NSMakeRange(curLocation, data.length-curLocation)] forProperty:keyType andRegulation:nil];
        
        curLocation += keyData.dataLangth;
        
        NSString *valueTyoe = regulation[2];
        ObjTypeReturnData *valueData = [ObjTypeTool getValueFromData:[data subdataWithRange:NSMakeRange(curLocation, data.length-curLocation)] forProperty:valueTyoe andRegulation:nil];
        
        curLocation += valueData.dataLangth;
        
#warning 可以加验证
        [mDic setValue:valueData.returnData forKey:keyData.returnData];
    }
    

    
    // 验证 Range 越界
    if (curLocation > data.length) {
        // 越界
        return nil;
    }
    
    return [ObjTypeReturnData returnData:mDic andDataLangth:curLocation];
}
+ (ObjTypeReturnData *)getArrayValueFromData:(NSData *)data forProperty:(NSString *)property andRegulation:(NSArray *)regulation{
    if (!data) {
        // 如果 data 缓存为空
        return nil;
    }
    //个数
    NSUInteger number = [ObjTypeTool langthByteNumberFormData:data];
    //起始位置
    NSUInteger curLocation = sizeof(uint16_t);
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int ergodicLocation = 0; ergodicLocation < number; ergodicLocation++) {
        //获得类型
        NSString *type =  regulation[1];
        
        ObjTypeReturnData *arrayData = [ObjTypeTool getValueFromData:[data subdataWithRange:NSMakeRange(curLocation, data.length-curLocation)] forProperty:type andRegulation:nil];
        
        curLocation += arrayData.dataLangth;
        
#warning 可以加验证
        [mArray addObject:arrayData.returnData];
    }

    
    // 验证 Range 越界
    if (curLocation > data.length) {
        // 越界
        return nil;
    }
    
    return [ObjTypeReturnData returnData:mArray andDataLangth:curLocation];
}
/**
 传入NSDictionary 返回NSData 序列化
 */
+ (NSData *)getDataForDictionary:(NSDictionary *)dictionary andRegulation:(NSArray *)regulation{
//空返回 uint16 0
    uint16_t number = dictionary.allKeys.count;
    NSMutableData *objData = [NSMutableData data];
    [objData appendData:[NSData dataWithBytes:&number length:sizeof(number)]];
    
    if (!dictionary || dictionary.allKeys.count == 0) {
        return objData;
    }
    for (NSString *key in dictionary.allKeys) {
        
        NSData *keyData = [ObjTypeTool getDataFormValue:key forProperty:regulation[1] andRegulation:nil];
        [objData appendData:keyData];
        
        id value = [dictionary valueForKey:[NSString stringWithFormat:@"%@", key]];
        NSData *valueData = [ObjTypeTool getDataFormValue:value forProperty:regulation[2] andRegulation:nil];
        [objData appendData:valueData];
    }
    return [objData mutableCopy];
}
/**
 传入NSArray 返回NSData 序列化
 */
+ (NSData *)getDataForArrya:(NSArray *)array andRegulation:(NSArray *)regulation{
//空返回 uint16 0
    
    uint16_t number = array.count;
    NSMutableData *objData = [NSMutableData data];
    [objData appendData:[NSData dataWithBytes:&number length:sizeof(number)]];
    
    if (!array || array.count == 0) {
        return objData;
    }
    
    for (id value in array) {
        NSData *keyData = [ObjTypeTool getDataFormValue:value forProperty:regulation[1] andRegulation:nil];
        [objData appendData:keyData];
    }
    return [objData mutableCopy];
}
@end
