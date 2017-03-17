//
//  MsgCenterSystemSecret.h
//  SocketClient
//
//  Created by Architray on 07/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgCenterSystemSecret : NSObject
@property (nonatomic, assign) NSUInteger uAgreementID;
@property (nonatomic, assign) NSUInteger uAssID;
@property (nonatomic, assign) uint32_t uSecretKey;
@property (nonatomic, assign) NSUInteger uTimeNow;
@property (nonatomic, assign) uint8_t u8Test;
- (instancetype)initWithData:(NSData *)data;
- (NSData *)toSecretData;

@end
