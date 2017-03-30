//
//  SCUserModulesSocket.m
//  SocketClient
//
//  Created by you hao on 2017/3/30.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCUserSocketManager.h"

//Tool
#import "DataCenter.h"
#import "SCSocketCenter.h"

//Delegate
#import "SCSocketDelegate.h"

@interface SCUserSocketManager()
<
    SCSocketDelegate
>

/** Tool */
@property (nonatomic, strong) DataCenter *dataCenter;
@property (nonatomic, strong) SCSocketCenter *socketCenter;

@end
@implementation SCUserSocketManager
#pragma mark - SCSocketDelegate
/**
 接收数据
 */
- (void)receiveModelForServiceReadData:(NSData *)data withTag:(long)tag{
    id objModel = [self.dataCenter objFromData:data];
    
    if ([self.userManagerdelegate respondsToSelector:@selector(receiveModelForManagerReadData:)]) {
        [self.userManagerdelegate receiveModelForManagerReadData:objModel];
    }
}

/**
 断开连接
 */
- (void)disconnectFromTheServer:(NSError *)error{
    if ([self.userManagerdelegate respondsToSelector:@selector(disconnectFromTheServer:)]) {
        [self.userManagerdelegate disconnectFromTheServer:error];
    }
}

#pragma mark - Interface
/** Login */
- (void)loginServer:(SCLogIn *)loginModel{
    [self.socketCenter sendMessageToTheServer:loginModel];
}
/** 连接服务器 */
- (BOOL)connectService{
    return [self.socketCenter connectService];
}
/** 注册 */
- (void)registerToServer:(SCRegistReq *)registReq{
    [self.socketCenter sendMessageToTheServer:registReq];
}

#pragma mark - Load
- (DataCenter *)dataCenter{
    if (!_dataCenter) {
        _dataCenter = [DataCenter sharedManager];
    }
    return _dataCenter;
}
- (SCSocketCenter *)socketCenter{
    if (!_socketCenter) {
        _socketCenter = [SCSocketCenter sharedManager];
        _socketCenter.socketdelegate = self;
    }
    return _socketCenter;
}
@end
