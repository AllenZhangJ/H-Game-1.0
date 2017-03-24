//
//  EncryptionModel.m
//  SocketClient
//
//  Created by Allen on 2017/3/7.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "EncryptionModel.h"

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
        NSRange agreementRange = NSMakeRange(uIndex, sizeof(INT32_MAX));
        NSData *pBufferData = [pBuffer subdataWithRange:agreementRange];
        
        uint32_t pBufferUnit = (uint32_t)pBufferData;
        pBufferUnit ^= uSecretKey1;
        pBufferUnit ^= uSecretKey2;
        pBufferUnit ^= uSecretKey3;
        
        [objData appendBytes:&pBufferUnit length:sizeof(uint32_t)];
        uIndex+= sizeof(INT32_MAX);
    }
    
    //不能被4整除部分
    while(uIndex<uLength){
        NSRange agreementRange = NSMakeRange(uIndex, sizeof(uint8_t));
        NSData *pBufferData = [pBuffer subdataWithRange:agreementRange];
        int32_t pBufferUnit = (int32_t)pBufferData;
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
    
    int32_t uSecretKey1 = uSecretKey;
    int32_t uSecretKey2 = uSecretKey1 + uSecretKey1+0xCBCEBCAA;
    int32_t uSecretKey3 = uSecretKey2 + uSecretKey1+0x20150909;
    
    uint uIndex =0;
    NSMutableData *objData = [NSMutableData data];
    
    while(uIndex + sizeof(INT32_MAX) < uLength){
        NSRange agreementRange = NSMakeRange(uIndex, sizeof(INT32_MAX));
        NSData *pBufferData = [pBuffer subdataWithRange:agreementRange];
        
        uint32_t pBufferUnit = (uint32_t)pBufferData;
        pBufferUnit ^= uSecretKey3;
        pBufferUnit ^= uSecretKey2;
        pBufferUnit ^= uSecretKey1;
        
        [objData appendBytes:&pBufferUnit length:sizeof(uint32_t)];
        uIndex+= sizeof(INT32_MAX);
    }
    
    //不能被4整除部分
    while(uIndex<uLength){
        NSRange agreementRange = NSMakeRange(uIndex, sizeof(uint8_t));
        NSData *pBufferData = [pBuffer subdataWithRange:agreementRange];
        int32_t pBufferUnit = (int32_t)pBufferData;
        pBufferUnit ^= uSecretKey3;
        pBufferUnit ^= uSecretKey2;
        pBufferUnit ^= uSecretKey1;
        
        [objData appendBytes:&pBufferUnit length:sizeof(uint8_t)];
        ++uIndex;
    }
    
    return [objData mutableCopy];
}
@end
