//
//  MsgSecret.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "MsgSecret.h"

@implementation MsgSecret

- (instancetype)initWithData:(NSData *)data{
    if (self = [super init]) {
        [self reserializeObj:data];
    }
    return self;
}

- (NSData *)toSecretData{
    return [self serializeObj];
}

@end
