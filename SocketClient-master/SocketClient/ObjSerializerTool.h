//
//  ObjSerializerTool.h
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

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
- (id)nextValueWithType:(const char *)propertyType;

/**
 将传入的值,根据类型,拼接到 objData 上

 @param value 值
 @param propertyType 类型
 @return  YES: 拼接成功;NO: 拼接不成功
 */
- (BOOL)appendDataForValue:(id)value andType:(const char *)propertyType;

@end
