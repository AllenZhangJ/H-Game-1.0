//
//  EncryptionModel.h
//  SocketClient
//
//  Created by Allen on 2017/3/7.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionModel : NSObject

/** <- 加密废弃 */
+ (NSData *)getEncryptionForKey:(uint32_t)uSecretKey andBuffer:(NSData *)pBuffer andLength:(uint16_t)uLength;
/** <- 解密废弃 */
+ (NSData *)getDecodeForKey:(uint32_t)uSecretKey andBuffer:(NSData *)pBuffer andLength:(uint16_t)uLength;

/**
 <- 加密
 
 @param uSecretKey Key
 @param pBuffer 拼接好的Data
 @param uLength 拼接好的Data.length
 @return 是否成功
 */
+ (BOOL)get_C_EncryptionForKey:(uint32_t)uSecretKey andBuffer:(char *)pBuffer andLength:(uint16_t)uLength;

/**
 <- 解密
 
 @param uSecretKey Key
 @param pBuffer 拼接好的Data
 @param uLength 拼接好的Data.length
 @return 是否成功
 */
+ (BOOL)get_C_DecodeForKey:(uint32_t)uSecretKey andBuffer:(char *)pBuffer andLength:(uint16_t)uLength;


/** 
    用户密码加密 
 */
+ (uint32_t)forEncryptedString:(NSString *)string;

@end
