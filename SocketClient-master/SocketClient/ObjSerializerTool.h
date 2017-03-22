//
//  ObjSerializerTool.h
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjModelPropertyType.h"

///////////////////////////////////////////////////////////////////////////

                    /* ObjTypeReturnData */

///////////////////////////////////////////////////////////////////////////
@interface ObjTypeReturnData : NSObject

@property (nonatomic ,strong) id returnData;

@property (nonatomic ,assign) NSUInteger dataLangth;
/**
 returnData  value
 dataLangth  总长度
 */
+ (id)returnData:(id)returnData andDataLangth:(NSUInteger)dataLangth;

@end

///////////////////////////////////////////////////////////////////////////

                    /* ObjSerializerTool */

///////////////////////////////////////////////////////////////////////////
@interface ObjSerializerTool : NSObject

@property (nonatomic, copy) NSData *objData;

/**
 判断是否有下一个数据
 原理:解析的"位置标识"是否大于等于 data 的长度

 @return YES: 有下一个; NO: 没有
 */
- (BOOL)hasNext;

/**
 根据传入的类型获取 data 中的下一个值

 @param type 类型
 @return 解析出的值
 */
- (id)nextValueWithType:(const char *)propertyType andRegulation:(NSArray *)regulation;

/**
 将传入的值,根据类型,拼接到 objData 上

 @param value 值
 @param propertyType 类型
 @return  YES: 拼接成功;NO: 拼接不成功
 */
- (BOOL)appendDataForValue:(id)value andType:(const char *)propertyType andRegulation:(NSArray *)regulation;

//得到长度
- (NSUInteger )getLength;
@end

///////////////////////////////////////////////////////////////////////////

                        /* ObjTypeTool */

///////////////////////////////////////////////////////////////////////////

@interface ObjTypeTool : NSObject

/**
 根据传入Data和"类型字符串"获取对应的OC值
 
 @param data Data
 @param property 类型字符串
 @return OC值+长度
 */
+ (ObjTypeReturnData *)getValueFromData:(NSData *)data forProperty:(NSString *)property andRegulation:(NSArray *)regulation;

/**
 根据传入类型字符串获取对应的枚举值
 
 @param property 类型字符串
 @return 类型枚举值
 */
+ (BaseModelPropertyType)propertyTypeOfProperty:(NSString *)property;


/**
 根据传入类型字符串 获取对应的C值 序列化
 */
+ (NSData *)getDataFormValue:(id)value forProperty:(NSString *)property andRegulation:(NSArray *)regulation;

@end

///////////////////////////////////////////////////////////////////////////

                    /* ObjContainerTool */

///////////////////////////////////////////////////////////////////////////
@interface ObjContainerTool : NSObject
/**  
 传入data返回NSDictionary 反序列化
 */
+ (ObjTypeReturnData *)getDicValueFromData:(NSData *)data forProperty:(NSString *)property andRegulation:(NSArray *)regulation;
/**
 传入data返回NSArray 反序列化
 */
+ (ObjTypeReturnData *)getArrayValueFromData:(NSData *)data forProperty:(NSString *)property andRegulation:(NSArray *)regulation;
/**
 传入NSDictionary 返回NSData 序列化
 */
+ (NSData *)getDataForDictionary:(NSDictionary *)dictionary andRegulation:(NSArray *)regulation;
/** 
 传入NSArray 返回NSData 序列化
 */
+ (NSData *)getDataForArrya:(NSArray *)array andRegulation:(NSArray *)regulation;
@end
