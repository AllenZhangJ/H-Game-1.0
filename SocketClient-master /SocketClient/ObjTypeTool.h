//
//  ObjTypeTool.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BaseModelPropertyType) {
    BaseModelPropertyType_Error = -1,
    BaseModelPropertyType_UInt32 = 1,
    BaseModelPropertyType_UInt64,
    BaseModelPropertyType_NSString,
};

extern NSString *const ObjTypeToolString_UInt32;
extern NSString *const ObjTypeToolString_UInt64;
extern NSString *const ObjTypeToolString_NSString;

@interface ObjTypeTool : NSObject

/**
 根据传入Data和"类型字符串"获取对应的OC值
 
 @param data Data
 @param property 类型字符串
 @return OC值
 */
+ (id)getValueFromData:(NSData *)data forProperty:(NSString *)property;

/**
 根据传入类型字符串获取对应的枚举值
 
 @param property 类型字符串
 @return 类型枚举值
 */
+ (BaseModelPropertyType)propertyTypeOfProperty:(NSString *)property;

/**
 根据传入类型枚举值获取对应的类型所占的字节数
 
 @param propertyType 类型枚举值
 @return 类型所占的字节数
 */
+ (NSUInteger)byteNumberForPropertyType:(BaseModelPropertyType)propertyType;
/** 
    字符描述部分获取长度
 */
+ (NSUInteger)stringByteNumberFormData:(NSData *)data;
@end
