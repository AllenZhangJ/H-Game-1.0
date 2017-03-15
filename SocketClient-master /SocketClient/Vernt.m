//
//  Vernt.m
//  SocketClient
//
//  Created by Allen on 2017/3/14.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "Vernt.h"

@implementation Vernt
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
