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
+ (BOOL)getEncryptionForKey:(uint32_t)uSecretKey andBuffer:(char *)pBuffer andLength:(uint)uLength{
    
    if (uLength <= 0) return nil;
    if (!pBuffer)return false;
    
    int32_t uSecretKey1 = uSecretKey;
    int32_t uSecretKey2 = uSecretKey1 + uSecretKey1+0xCBCEBCAA;
    int32_t uSecretKey3 = uSecretKey2 + uSecretKey1+0x20150909;
    
    uint uIndex =0;
    
    //能被4整除部分
    while(uIndex + sizeof(uSecretKey1) < uLength){
        int32_t* pBufferUnit = (int32_t*)&pBuffer[uIndex];
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
    return NO;
}
/** 解密 */
+ (BOOL)getDecodeForKey:(uint32_t)uSecretKey andBuffer:(char *)pBuffer andLength:(uint)uLength{
    if (uLength<=0)return false;
    if (!pBuffer)return false;
    
    int32_t uSecretKey1 = uSecretKey;
    int32_t uSecretKey2 = uSecretKey1 + uSecretKey1+0xCBCEBCAA;
    int32_t uSecretKey3 = uSecretKey2 + uSecretKey1+0x20150909;
    
    uint uIndex =0;
    
    //能被4整除部分
    while(uIndex + sizeof(uSecretKey1) < uLength){
        int32_t* pBufferUnit = (int32_t*)&pBuffer[uIndex];
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
@end
