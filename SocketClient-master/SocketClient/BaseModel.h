//
//  BaseModel.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDelegate.h"

/** ENUM */
#import "SCAgreementType.h"
#import "ObjModelPropertyType.h"

@interface BaseModel : NSObject
<
    ModelDelegate
>

/**
 反序列化

 @param data 二进制流
 @return 返回值类型可以为 void
 */
- (instancetype)reserializeObj:(NSData *)data andAgreementID:(uint32_t)agreementID;

/**
 序列化

 @return 序列化之后的二进制流
 */
- (NSData *)serializeObj;

/** 
    发送用初始化方法
 */
- (instancetype)initWithSendToAgreementID:(uint32_t)agreementID;

/**
 规则目录
*/
- (NSDictionary *)getRegulation;

/** 
 接口对应顺序规则
 */
- (NSDictionary *)getInterfaceRegulation;

/** 
 长度
 */
- (NSUInteger)returnModelLength;
@end
