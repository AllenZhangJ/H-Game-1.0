//
//  ObjSerializerTool.h
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjSerializerTool : NSObject
///** 序列化 拼接 */
+ (NSData *)private_valueJoinDataAtValue:(id)value Type:(const char *)propertyType;
/** 反序列化 获得Value */
+ (id)private_valueFromData:(NSData *)dataCache andAtLocation:(NSUInteger *)location andPropertyType:(const char *)propertyType;
@end
