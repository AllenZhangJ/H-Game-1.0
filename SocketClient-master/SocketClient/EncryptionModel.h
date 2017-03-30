//
//  EncryptionModel.h
//  SocketClient
//
//  Created by Allen on 2017/3/7.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionModel : NSObject

/**
 加密

 @param uSecretKey Key
 @param pBuffer 拼接好的Data
 @param uLength 拼接好的Data.length
 @return NSData
 */
+ (NSData *)getEncryptionForKey:(uint32_t)uSecretKey andBuffer:(NSData *)pBuffer andLength:(uint16_t)uLength;
/**
 解密
 
 @param uSecretKey Key
 @param pBuffer 拼接好的Data
 @param uLength 拼接好的Data.length
 @return NSData
 */
+ (NSData *)getDecodeForKey:(uint32_t)uSecretKey andBuffer:(NSData *)pBuffer andLength:(uint16_t)uLength;

/** 
    用户密码加密 
 */
+ (uint32_t)forEncryptedString:(NSString *)string;

@end
