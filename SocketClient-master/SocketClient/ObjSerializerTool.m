//
//  ObjSerializerTool.m
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "ObjSerializerTool.h"

#include "ObjTypeTool.h"

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

- (id)nextValueWithType:(const char *)propertyType{
    return [self private_valueForPropertyType:propertyType];
}

- (BOOL)appendDataForValue:(id)value andType:(const char *)propertyType{
    
    NSData *dataTmp = [self private_valueJoinDataAtValue:value
                                                 andType:propertyType];
    if (!dataTmp || dataTmp.length == 0) {
        // 为空,或者长度为0
        return NO;
    }
    [self.appendedData appendData:dataTmp];
    
    return YES;
}

#pragma mark - Private
///** 序列化 拼接 */
- (NSData *)private_valueJoinDataAtValue:(id)value andType:(const char *)propertyType{
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
    NSData *valueData = [ObjTypeTool getDataFormValue:value forProperty:typeString];
    
    //验证
    if (!valueData) {
        //值为空
        return nil;
    }
    return valueData;
}

/** 反序列化 获得Value */
- (id)private_valueForPropertyType:(const char *)propertyType{
    if (!_objData) {
        // 如果 data 缓存为空
        return nil;
    }
    
    NSString *stringType =  [NSString stringWithCString:propertyType
                                               encoding:NSUTF8StringEncoding];
    // 获取类型
    BaseModelPropertyType type = [ObjTypeTool propertyTypeOfProperty:stringType];
        
    ObjTypeReturnData *returnData = [ObjTypeTool getValueFromData:[_objData subdataWithRange:NSMakeRange(_curLocation, _objData.length-_curLocation)] forProperty:stringType];
    if (!returnData.returnData) {
        // 值为空
        return nil;
    }
    
    NSUInteger typeLangth = returnData.dataLangth;
    //获得长度
//    if (type == BaseModelPropertyType_NSString) {// 判断是否为字符串类型
//        typeLangth += sizeof(uint16_t);
//    }
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
