//
//  ObjSerializerTool.m
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "ObjSerializerTool.h"

#include "ObjModelPropertyType.h"

/** 结构体 */
#import "XTest.h"
#import "XAccountInfo.h"

static const NSUInteger kObjTypeToolStringHeaderLength = sizeof(uint16_t);
static NSDictionary *kTypeCatalogueDic;


///////////////////////////////////////////////////////////////////////////

/* ObjPacketHeader */

///////////////////////////////////////////////////////////////////////////
#pragma mark - ObjPacketHeader
@implementation ObjPacketHeader
/**
 接到objData拆分包头
 @return  ObjPacketHeader
 */
+ (ObjPacketHeader *)returnPacketHeaderForData:(NSData *)objData{
    ObjPacketHeader *packetHeader = [ObjPacketHeader new];
    
    uint16_t tmpLength;
    //得到长度
    NSData *lengthData = [objData subdataWithRange:NSMakeRange(0, sizeof(uint16_t))];
    [lengthData getBytes:&tmpLength length:sizeof(uint16_t)];
    packetHeader.packetLength = tmpLength;
    
    uint16_t tmpAgreement;
    //得到协议号
    NSData *agreementData = [objData subdataWithRange:NSMakeRange(sizeof(uint16_t), sizeof(uint16_t))];
    [agreementData getBytes:&tmpAgreement length:sizeof(uint16_t)];
    packetHeader.packetAgreementID = tmpAgreement;
    
    return packetHeader;
}

/**
 根据包长度及协议号 拼接出Data
 @return  NSData
 */
+ (NSData *)returnDataForPacketLength:(uint16_t)packetLength andpacketAgreementID:(uint16_t)packetAgreementID{
    NSMutableData *returnData = [NSMutableData data];
    
    uint16_t tmpPacketLength = packetLength;
    //加上包头长度
    tmpPacketLength += sizeof(uint32_t);
    
    //拼接长度
    [returnData appendData:[NSData dataWithBytes:&tmpPacketLength length:sizeof(uint16_t)]];
    
    //拼接协议号
    [returnData appendData:[NSData dataWithBytes:&packetAgreementID length:sizeof(uint16_t)]];
    
    return [returnData mutableCopy];
}
+ (NSData *)returnDataForPacketHeader:(ObjPacketHeader *)packetHeader{
    return [self returnDataForPacketLength:packetHeader.packetLength andpacketAgreementID:packetHeader.packetAgreementID];
}

@end

///////////////////////////////////////////////////////////////////////////

/* ObjTypeReturnData */

///////////////////////////////////////////////////////////////////////////
#pragma mark - ObjTypeReturnData
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
#pragma mark - ObjSerializerTool
@interface ObjSerializerTool(){
    NSUInteger _curLocation;// 记录当前解析的位置
}

@property (nonatomic, copy) NSMutableData *appendedData;

@end

@implementation ObjSerializerTool
- (BOOL)hasNext{
    if (_objData.length > _curLocation) {
        return YES;
    }
    return NO;
}

- (id)nextValueWithRegulation:(NSArray *)regulation{
    return [self private_valueForRegulation:regulation];
}

- (BOOL)appendDataForValue:(id)value andRegulation:(NSArray *)regulation{
    
    NSData *dataTmp = [self private_valueJoinDataAtValue:value andRegulation:regulation];
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
- (NSData *)private_valueJoinDataAtValue:(id)value andRegulation:(NSArray *)regulation{
    //判断为空
    if (!value) {
        return nil;
    }
    
    //拼接
    NSData *valueData = [ObjTypeTool getDataFormValue:value forRegulation:regulation];
    
    //验证
    if (!valueData) {
        //值为空
        return nil;
    }
    return valueData;
}

/** 反序列化 获得Value */
- (id)private_valueForRegulation:(NSArray *)regulation{
    if (!_objData) {
        // 如果 data 缓存为空
        return nil;
    }
    
    ObjTypeReturnData *returnData = [ObjTypeTool getValueFromData:[_objData subdataWithRange:NSMakeRange(_curLocation, _objData.length-_curLocation)] forRegulation:regulation];
    
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
#pragma mark - ObjTypeTool
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
+ (ObjTypeReturnData *)getValueFromData:(NSData *)data forRegulation:(NSArray *)regulation{
    if (!data || data.length <= 0) {
        return nil;
    }
    BaseModelPropertyType type = [self propertyTypeOfProperty:regulation[0]];
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
            return [ObjContainerTool getDicValueFromData:data forRegulation:regulation];
        }
            break;
        case BaseModelPropertyType_NSArray:{
            return [ObjContainerTool getArrayValueFromData:data forRegulation:regulation];
        }
            break;
        case BaseModelPropertyType_XTest:{
            XTest *xTestData = [[XTest alloc]reserializeObj:data andAgreementID:0];
            return [ObjTypeReturnData returnData:xTestData andDataLangth:[xTestData returnModelLength]];
        }
            break;
        case BaseModelPropertyType_XAccountInfo:{
            XAccountInfo *xAccounInfo = [[XAccountInfo alloc]reserializeObj:data andAgreementID:0];
            return [ObjTypeReturnData returnData:xAccounInfo andDataLangth:[xAccounInfo returnModelLength]];
        }
            break;
        default:
            return nil;
            break;
    }
}

//根据传入data
+ (NSUInteger)langthByteNumberFormData:(NSData *)data{
    if (!data || data.length <= kObjTypeToolStringHeaderLength) {
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
    return [[kTypeCatalogueDic valueForKey:property] integerValue];
}

/**
 根据传入类型字符串 获取对应的data 序列化
 */
+ (NSData *)getDataFormValue:(id)value forRegulation:(NSArray *)regulation{
    BaseModelPropertyType type = [self propertyTypeOfProperty:regulation.firstObject];
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
        case BaseModelPropertyType_XTest:{
            XTest *tmp_xTest = value;
            return [tmp_xTest serializeObj];
        }
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
#pragma mark - ObjContainerTool
@interface ObjContainerTool (){
    NSUInteger _curLocation;// 记录当前解析的位置
}

@property (nonatomic, copy) NSMutableData *appendedData;

@end

@implementation ObjContainerTool
+ (ObjTypeReturnData *)getDicValueFromData:(NSData *)data forRegulation:(NSArray *)regulation{
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
        
        //截取数组 除第一个元素之外的后面所有元素 如果有嵌套字典 才能触发递归，第一位是本身的类型.
        NSArray *keyRegulation = [regulation subarrayWithRange:NSMakeRange(1, regulation.count - 1)];
        ObjTypeReturnData *keyData = [ObjTypeTool getValueFromData:[data subdataWithRange:NSMakeRange(curLocation, data.length-curLocation)] forRegulation:keyRegulation];             //regulation[1]
        
        curLocation += keyData.dataLangth;
        
        NSArray *valueRegulation = [regulation subarrayWithRange:NSMakeRange(2, regulation.count - 2)];
        ObjTypeReturnData *valueData = [ObjTypeTool getValueFromData:[data subdataWithRange:NSMakeRange(curLocation, data.length-curLocation)] forRegulation:valueRegulation];   //regulation[2]
        
        curLocation += valueData.dataLangth;
        
#warning 可以加验证
        [mDic setObject:valueData.returnData forKey:keyData.returnData];
    }
    
    
    
    // 验证 Range 越界
    if (curLocation > data.length) {
        // 越界
        return nil;
    }
    
    return [ObjTypeReturnData returnData:mDic andDataLangth:curLocation];
}
+ (ObjTypeReturnData *)getArrayValueFromData:(NSData *)data forRegulation:(NSArray *)regulation{
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
        
        //截取数组 除第一个元素之外的后面所有元素 如果有嵌套数组 才能触发递归，第一位是本身的类型.
        NSArray *arrayRegulation = [regulation subarrayWithRange:NSMakeRange(1, regulation.count - 1)];
        ObjTypeReturnData *arrayData = [ObjTypeTool getValueFromData:[data subdataWithRange:NSMakeRange(curLocation, data.length-curLocation)] forRegulation:arrayRegulation];
        
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
        //截取数组 除第一个元素之外的后面所有元素 如果有嵌套字典 才能触发递归，第一位是本身的类型.
        NSArray *keyRegulation = [regulation subarrayWithRange:NSMakeRange(1, regulation.count - 1)];
        NSData *keyData = [ObjTypeTool getDataFormValue:key forRegulation:keyRegulation];
        [objData appendData:keyData];
        
        NSArray *valueRegulation = [regulation subarrayWithRange:NSMakeRange(2, regulation.count - 2)];
        id value = [dictionary objectForKey:key];
        NSData *valueData = [ObjTypeTool getDataFormValue:value forRegulation:valueRegulation];
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
    
    //截取数组 除第一个元素之外的后面所有元素 如果有嵌套数组 才能触发递归，第一位是本身的类型.
    NSArray *arrayRegulation = [regulation subarrayWithRange:NSMakeRange(1, regulation.count - 1)];
    for (id value in array) {
        NSData *keyData = [ObjTypeTool getDataFormValue:value forRegulation:arrayRegulation];
        [objData appendData:keyData];
    }
    return [objData mutableCopy];
}
@end
