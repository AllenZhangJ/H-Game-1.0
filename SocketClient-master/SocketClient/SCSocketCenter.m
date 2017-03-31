//
//  SCSocketCenter.m
//  SocketClient
//
//  Created by you hao on 2017/3/28.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCSocketCenter.h"

/** 3f */
#import "GCDAsyncSocket.h"

/** Model */
#import "DataCenter.h"

static SCSocketCenter *socketCenter = nil;
static NSString *const LANURLstr = @"192.168.1.139";
static NSString *const LANURLstr_text = @"192.168.1.138";
static NSString *const LANURLstr_LJ = @"192.168.1.140";
static NSString *const URLstr = @"hydemo.hao-games.com";
static NSInteger const PortInt = 11000;

@interface SCSocketCenter ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) DataCenter *dataCenter;

//客户端socket
@property (nonatomic) GCDAsyncSocket *clinetSocket;

//计时器
@property (nonatomic, retain) NSTimer *connectTimer;

@end

@implementation SCSocketCenter

#pragma mark - Shared
+(SCSocketCenter *)sharedManager{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        if(!socketCenter){
            socketCenter = [[SCSocketCenter alloc]init];
        }
    });
    return socketCenter;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!socketCenter) {
            socketCenter = [super allocWithZone:zone];
            return socketCenter;
        }
        return nil;
    }
}

- (id)init{
    if (self = [super init]) {
        self = socketCenter;
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
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    // 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    
    [self.connectTimer fire];
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [self receiveDataForServiceReadData:data withTag:tag];
    [self.clinetSocket readDataWithTimeout:-1 tag:tag];
}

//连接服务器
- (BOOL)connectAction{
    NSError *error = nil;
    if (![self.clinetSocket connectToHost:URLstr onPort:PortInt withTimeout:-1 error:&error]) {
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
    if (!err) {
        [self.socketdelegate disconnectFromTheServer:err];
    }else{
        [self connectAction];
    }
}

#pragma mark - Private
/** 心跳包 */
- (void)longConnectToSocket{
#warning 传合理的包即可
    
    
}

#pragma mark - load
- (DataCenter *)dataCenter{
    if (!_dataCenter) {
        _dataCenter = [DataCenter sharedManager];
    }
    return _dataCenter;
}
@end
