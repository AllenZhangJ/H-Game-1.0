//
//  DataCenter.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelDelegate.h"

typedef NS_ENUM(UInt32, OBJ_InstanceType) {
    OBJ_InstanceType_MCSS = 106102800,
    OBJ_InstanceType_MsgSecret = 106102800,// 包头号,对应的类
    OBJ_InstanceType_MsgSecretTest = 1619,  //欢迎包
    OBJ_InstanceType_Login = 1905,          //登录包
    OBJ_InstanceType_LoginMsg = 1890,       //登陆后信息
};

@interface DataCenter : NSObject

- (id<ModelDelegate>)objFromData:(NSData *) data;

- (NSData *)dataFromInstance:(id<ModelDelegate>) instance;

@end
