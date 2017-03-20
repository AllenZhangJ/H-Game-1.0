//
//  Vector.h
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDelegate.h"
@interface SCVectorBase : NSObject
//- (id)initWithFormData:(NSData *)data andDataAllNumber:(NSUInteger )number;
@end
@interface SCMapBase : NSDictionary
<
    ModelDelegate
>
/**
 反序列化
 
 @param data 二进制流
 @return 返回值类型可以为 void
 */
- (instancetype)reserializeObj:(NSData *)data;

/**
 序列化
 
 @return 序列化之后的二进制流
 */
- (NSData *)serializeObj;
@end
