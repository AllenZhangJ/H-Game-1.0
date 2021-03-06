//
//  EncryptionModel.m
//  SocketClient
//
//  Created by Allen on 2017/3/7.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "EncryptionModel.h"

#define kHASHKey 0xCFEBCFEB

@implementation EncryptionModel
/** 加密 */
+ (NSData *)getEncryptionForKey:(uint32_t)uSecretKey andBuffer:(NSData *)pBuffer andLength:(uint16_t)uLength{
    if (uLength <= 0) return nil;
    if (!pBuffer)return nil;
    
    uint32_t uSecretKey1 = uSecretKey;
    uint32_t uSecretKey2 = uSecretKey1 + uSecretKey1+0xCBCEBCAA;
    uint32_t uSecretKey3 = uSecretKey2 + uSecretKey1+0x20150909;
    
    uint uIndex =0;
    NSMutableData *objData = [NSMutableData data];
    //能被4整除部分
    while(uIndex + sizeof(INT32_MAX) < uLength){
        NSData *pBufferData = [pBuffer subdataWithRange:NSMakeRange(uIndex, sizeof(INT32_MAX))];
        uint32_t pBufferUnit;
        [pBufferData getBytes:&pBufferUnit length:sizeof(uint32_t)];
//        uint32_t pBufferUnit = (uint32_t)pBufferData;
        pBufferUnit ^= uSecretKey1;
        pBufferUnit ^= uSecretKey2;
        pBufferUnit ^= uSecretKey3;
        
        [objData appendBytes:&pBufferUnit length:sizeof(pBufferUnit)];
        uIndex+= sizeof(INT32_MAX);
    }
    
    //不能被4整除部分
    while(uIndex<uLength){
        NSData *pBufferData = [pBuffer subdataWithRange:NSMakeRange(uIndex, sizeof(uint8_t))];
        uint8_t pBufferUnit;
        [pBufferData getBytes:&pBufferUnit length:sizeof(uint8_t)];
        pBufferUnit ^= uSecretKey1;
        pBufferUnit ^= uSecretKey2;
        pBufferUnit ^= uSecretKey3;
        
        [objData appendBytes:&pBufferUnit length:sizeof(uint8_t)];
        ++uIndex;
    }

    return [objData mutableCopy];
}
/** 解密 */
+ (NSData *)getDecodeForKey:(uint32_t)uSecretKey andBuffer:(NSData *)pBuffer andLength:(uint16_t)uLength{
    if (uLength<=0)return nil;
    if (!pBuffer)return nil;
    
    uint32_t uSecretKey1 = uSecretKey;
    uint32_t uSecretKey2 = uSecretKey1 + uSecretKey1+0xCBCEBCAA;
    uint32_t uSecretKey3 = uSecretKey2 + uSecretKey1+0x20150909;
    
    uint uIndex =0;
    NSMutableData *objData = [NSMutableData data];
    //能被4整除部分
    while(uIndex + sizeof(INT32_MAX) < uLength){
        NSData *pBufferData = [pBuffer subdataWithRange:NSMakeRange(uIndex, sizeof(INT32_MAX))];
        uint32_t pBufferUnit;
        [pBufferData getBytes:&pBufferUnit length:sizeof(uint32_t)];
        pBufferUnit ^= uSecretKey3;
        pBufferUnit ^= uSecretKey2;
        pBufferUnit ^= uSecretKey1;
        
        [objData appendBytes:&pBufferUnit length:sizeof(pBufferUnit)];
        uIndex+= sizeof(INT32_MAX);
    
    }
    
    //不能被4整除部分
    while(uIndex<uLength){
        NSData *pBufferData = [pBuffer subdataWithRange:NSMakeRange(uIndex, sizeof(uint8_t))];
        uint8_t pBufferUnit;
        [pBufferData getBytes:&pBufferUnit length:sizeof(uint8_t)];
        pBufferUnit ^= uSecretKey3;
        pBufferUnit ^= uSecretKey2;
        pBufferUnit ^= uSecretKey1;
        
        [objData appendBytes:&pBufferUnit length:sizeof(uint8_t)];
        ++uIndex;
    }
    
    return [objData mutableCopy];
}

+ (BOOL)get_C_EncryptionForKey:(uint32_t)uSecretKey andBuffer:(char *)pBuffer andLength:(uint16_t)uLength{

    if (uLength<=0)return false;
    if (!pBuffer)return false;
    
    uint32_t uSecretKey1 = uSecretKey;
    uint32_t uSecretKey2 = uSecretKey1 + uSecretKey1+0xCBCEBCAA;
    uint32_t uSecretKey3 = uSecretKey2 + uSecretKey1+0x20150909;
    
    uint uIndex =0;
    
    //能被4整除部分
    while(uIndex + sizeof(uSecretKey1) < uLength){
        uint32_t* pBufferUnit = (uint32_t*)&pBuffer[uIndex];
        *pBufferUnit ^= uSecretKey1;
        *pBufferUnit ^= uSecretKey2;
        *pBufferUnit ^= uSecretKey3;
        
        uIndex+= sizeof(uSecretKey1);
    }
    
    //不能被4整除部分
    while(uIndex<uLength){
        pBuffer[uIndex] ^= uSecretKey1;
        pBuffer[uIndex] ^= uSecretKey2;
        pBuffer[uIndex] ^= uSecretKey3;
        
        ++uIndex;
    }
    return true;
}

+ (BOOL)get_C_DecodeForKey:(uint32_t)uSecretKey andBuffer:(char *)pBuffer andLength:(uint16_t)uLength{
    if (uLength<=0)return false;
    if (!pBuffer)return false;
    
    uint32_t uSecretKey1 = uSecretKey;
    uint32_t uSecretKey2 = uSecretKey1 + uSecretKey1+0xCBCEBCAA;
    uint32_t uSecretKey3 = uSecretKey2 + uSecretKey1+0x20150909;
    
    uint uIndex =0;
    
    //能被4整除部分
    while(uIndex + sizeof(uSecretKey1) < uLength){
        uint32_t* pBufferUnit = (uint32_t*)&pBuffer[uIndex];
        *pBufferUnit ^= uSecretKey3;
        *pBufferUnit ^= uSecretKey2;
        *pBufferUnit ^= uSecretKey1;
        
        uIndex+= sizeof(uSecretKey1);
    }
    
    //不能被4整除部分
    while(uIndex<uLength){
        pBuffer[uIndex] ^= uSecretKey3;
        pBuffer[uIndex] ^= uSecretKey2;
        pBuffer[uIndex] ^= uSecretKey1;
        
        ++uIndex;
    }
    return true;
}

/** 用户密码加密 */
+ (uint32_t)forEncryptedString:(NSString *)string{
    uint32_t encryptedInt;
    NSUInteger hashInt = [string hash];
    encryptedInt = [NSNumber numberWithUnsignedInteger:hashInt].unsignedIntValue;
    encryptedInt ^= kHASHKey;
    return encryptedInt;
}


@end
