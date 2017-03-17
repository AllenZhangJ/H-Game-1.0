//
//  BaseModel.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDelegate.h"

@interface BaseModel : NSObject
<
    ModelDelegate
>

@property (nonatomic, assign) UInt32 uAgreementID;// 包头

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
