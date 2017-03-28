//
//  SCSocketConter.m
//  SocketClient
//
//  Created by you hao on 2017/3/28.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCSocketConter.h"

/** 3f */
#import "GCDAsyncSocket.h"

/** Model */
#import "DataCenter.h"

static SCSocketConter *socketConter = nil;
static NSString *const LANURLstr = @"192.168.1.139";
static NSString *const LANURLstr_text = @"192.168.1.138";
static NSString *const LANURLstr_LJ = @"192.168.1.140";
static NSString *const URLstr = @"hydemo.hao-games.com";
static NSInteger const PortInt = 11000;

@interface SCSocketConter ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) DataCenter *dataCenter;

//客户端socket
@property (nonatomic) GCDAsyncSocket *clinetSocket;

@end

@implementation SCSocketConter

#pragma mark - Shared
+(SCSocketConter *)sharedManager{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        if(!socketConter) socketConter = [[SCSocketConter alloc]init];
    });
    return socketConter;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!socketConter) {
            socketConter = [super allocWithZone:zone];
            return socketConter;
        }
        return nil;
    }
}

- (id)init{
    if (self = [super init]) {
        self.clinetSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

#pragma mark - Interface
/** 连接服务器 */
- (BOOL)connectService{
   return [self connectAction];
}

/** 收到消息 */
- (void)receiveDataForServiceReadData:(NSData *)data withTag:(long)tag{
    // 判断代理对象是否实现这个方法，没有实现会导致崩溃
    if ([self.socketdelegate respondsToSelector:@selector(receiveModelForServiceReadData:withTag:)]) {
        // 调用代理对象的登录方法，代理对象去实现
        [self.socketdelegate receiveModelForServiceReadData:data withTag:tag];
    }
}

/** 发送消息 */
- (void)sendMessageToTheServer:(id)obj{
    NSData *ObjdData = [self.dataCenter dataFromInstance:obj];
    [self.clinetSocket writeData:ObjdData withTimeout:1 tag:0];
}


#pragma mark - GCDAsynSocket Delegate
//建立连接
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"链接成功:服务器IP ： %@", host);
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [self receiveDataForServiceReadData:data withTag:tag];
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}

//连接服务器
- (BOOL)connectAction{
    NSError *error = nil;
    if (![self.clinetSocket connectToHost:LANURLstr_text onPort:PortInt withTimeout:-1 error:&error]) {
#warning 提示连接失败
        NSLog(@"Failed to connect to server!\n ERROR:%@", error.userInfo[@"NSLocalizedDescription"]);
        return NO;
    }
    return YES;
}

//接收消息
- (void)receiveMessageAction{
    [self.clinetSocket readDataWithTimeout:10 tag:0];
}
#pragma  mark - Bak
//读超时
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length{

    return 0;
}
//写超时
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length{
    return 0;
}

//这个方法一定要注意，是GCD下，Socket连接断开的时候调用，无论此时是正常断开还是异常断开。正常断开err为空
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
#warning 判断是否需要立刻重连
    if (!err) {
        //正常断开
        NSLog(@"[SocketCenter] In order to normal and server disconnect!");
    }else{
        NSLog(@"[SocketCenter] Abnormal disconnect the server!ERROR:%@", err.userInfo[@"NSLocalizedDescription"]);
    }
}
#pragma mark - load
- (DataCenter *)dataCenter{
    if (!_dataCenter) {
        _dataCenter = [DataCenter sharedManager];
    }
    return _dataCenter;
}
@end
