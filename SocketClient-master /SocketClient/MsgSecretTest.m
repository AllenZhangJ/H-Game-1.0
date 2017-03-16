//
//  MsgSecretTest.m
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "MsgSecretTest.h"

@implementation MsgSecretTest
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
