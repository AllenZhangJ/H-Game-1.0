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
 @param pBuffer 拼接好的字符串
 @param uLength 拼接好的字符串长度
 @return 是否成功
 */
+ (BOOL)getEncryptionForKey:(uint32_t)uSecretKey andBuffer:(char *)pBuffer andLength:(uint)uLength;
/**
 解密
 
 @param uSecretKey Key
 @param pBuffer 拼接好的字符串
 @param uLength 拼接好的字符串长度
 @return 是否成功
 */
+ (BOOL)getDecodeForKey:(uint32_t)uSecretKey andBuffer:(char *)pBuffer andLength:(uint)uLength;
@end
