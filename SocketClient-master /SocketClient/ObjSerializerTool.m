//
//  ObjSerializerTool.m
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "ObjSerializerTool.h"
#include "ObjTypeTool.h"
@implementation ObjSerializerTool
///** 序列化 拼接 */
+ (NSData *)private_valueJoinDataAtValue:(id)value Type:(const char *)propertyType{
    //判断为空
    if (!value) {
        return nil;
    }
    //获取类型
    NSString *stringType =  [NSString stringWithCString:propertyType
                                               encoding:NSUTF8StringEncoding];
    // 获取类型
    //    BaseModelPropertyType type = [ObjTypeTool propertyTypeOfProperty:stringType];
    
    //拼接
    NSData *valueData = [ObjTypeTool getDataFormValue:value forProperty:stringType];
    
    //验证
    if (!valueData) {
        //值为空
        return nil;
    }
    return valueData;
}
/** 反序列化 获得Value */
+ (id)private_valueFromData:(NSData *)dataCache andAtLocation:(NSUInteger *)location andPropertyType:(const char *)propertyType{
    if (!dataCache) {
        // 如果 data 缓存为空
        return nil;
    }
    
    NSString *stringType =  [NSString stringWithCString:propertyType
                                               encoding:NSUTF8StringEncoding];
    // 获取类型
    BaseModelPropertyType type = [ObjTypeTool propertyTypeOfProperty:stringType];
    
    NSUInteger typeLangth = 0;
    //获得长度
    if (type == BaseModelPropertyType_NSString) {// 判断是否为字符串类型
        //字符串长度获取
        typeLangth = [ObjTypeTool stringByteNumberFormData:[dataCache subdataWithRange:NSMakeRange(*location, dataCache.length - *location)]];
        typeLangth += sizeof(uint16_t);
    }else {
        typeLangth = [ObjTypeTool byteNumberForPropertyType:type];
    }
    //获得长度
    NSRange rangeTmp = NSMakeRange(*location, typeLangth);
    
    // 验证 Range 越界
    if (*location + typeLangth > dataCache.length) {
        // 越界
        return nil;
    }
    
    //获得Value
    id value = [ObjTypeTool getValueFromData:[dataCache subdataWithRange:rangeTmp]
                                 forProperty:stringType];
    
    if (!value) {
        // 值为空
        return nil;
    }
    // 更新位置
    *location += typeLangth;
    
    return value;
}
@end
