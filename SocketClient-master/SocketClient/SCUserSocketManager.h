//
//  SCUserModulesSocket.h
//  SocketClient
//
//  Created by you hao on 2017/3/30.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
//Model
#import "SCLogIn.h"
#import "SCRegistReq.h"

@protocol SCUserSocketManagerDelegate <NSObject>

- (void)receiveModelForManagerReadData:(id)objData;

@optional

- (void)disconnectFromTheServer:(NSError *)error;

@end
@interface SCUserSocketManager : NSObject

@property (nonatomic ,weak) id<SCUserSocketManagerDelegate> userManagerdelegate;

/** Login */
- (void)loginServer:(SCLogIn *)loginModel;

/** 连接服务器 */
- (BOOL)connectService;

/** 注册 */
- (void)registerToServer:(SCRegistReq *)registReq;

@end
