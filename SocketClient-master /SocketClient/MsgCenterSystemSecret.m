//
//  MsgCenterSystemSecret.m
//  SocketClient
//
//  Created by Architray on 07/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "MsgCenterSystemSecret.h"

typedef struct{
    uint32_t uAgreementID;
    uint32_t uAssID;
    uint32_t uSecretKey;
    uint32_t uTimeNow;
    uint8_t u8Test;
}MsgCntSysSecret;

@interface MsgCenterSystemSecret (){
    MsgCntSysSecret secret;
}

@end

@implementation MsgCenterSystemSecret

- (instancetype)initWithData:(NSData *)data{
    if (self = [super init]) {
        [data getBytes:&secret
                length:sizeof(secret)];
    }
    return self;
}

- (NSData *)toSecretData{
    return [NSData dataWithBytes:&secret
                          length:sizeof(secret)];
}

#pragma mark - Getters
- (NSUInteger)uAssID{
    return secret.uAssID;
}
- (uint32_t)uSecretKey{
    return secret.uSecretKey;
}
- (NSUInteger)uTimeNow{
    return secret.uTimeNow;
}
- (NSUInteger)uAgreementID{
    return secret.uAgreementID;
}
#pragma mark - Setters
- (void)setUAssID:(NSUInteger)uAssID{
    secret.uAssID = (UInt32)uAssID;
}
- (void)uSecretKey:(NSUInteger)uSecretKey{
    secret.uSecretKey = (UInt32)uSecretKey;
}
- (void)setUTimeNow:(NSUInteger)uTimeNow{
    secret.uTimeNow = (UInt32)uTimeNow;
}
- (void)setuAgreementID:(NSUInteger)uAgreementID{
    secret.uAgreementID = (UInt32)uAgreementID;
}
@end
