//
//  SCSocketetDelegate.h
//  SocketClient
//
//  Created by you hao on 2017/3/28.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCSocketDelegate <NSObject>

/**
    接收数据
 */
- (void)receiveModelForServiceReadData:(NSData *)data withTag:(long)tag;

@optional

@end
