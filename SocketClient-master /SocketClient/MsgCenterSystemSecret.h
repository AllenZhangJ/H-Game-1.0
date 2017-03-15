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

- (instancetype)initWithData:(NSData *)data;
- (NSData *)toSecretData;

@end
