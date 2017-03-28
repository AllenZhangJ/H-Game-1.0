//
//  SCSocketConter.h
//  SocketClient
//
//  Created by you hao on 2017/3/28.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Delegate */
#import "SCSocketDelegate.h"

@interface SCSocketConter : NSObject

@property (nonatomic, weak) id<SCSocketDelegate> socketdelegate;

/**
 连接服务器
 */
- (BOOL)connectService;

/**
 发送消息
 @return 是否把消息发送成功
 */
- (void)sendMessageToTheServer:(id)obj;

/** shared */
+ (SCSocketConter *)sharedManager;
@end
