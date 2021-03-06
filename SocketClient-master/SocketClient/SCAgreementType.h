//
//  SCAgreementType.h
//  SocketClient
//
//  Created by you hao on 2017/3/31.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(UInt32, OBJ_InstanceType) {
    /** -- Receive -- */
    OBJ_InstanceType_MsgSecretTest = 1619,              //欢迎包
    OBJ_InstanceType_LoginMsg = 1890,                   //登陆后信息
    /** Center */
    OBJ_InstanceType_MsgCenterLoginRep = 1906,          //登录反馈
    OBJ_InstanceType_MsgCenterAccountNtf = 2083,        //用户信息
    OBJ_InstanceType_MSGCenterRegister = 1794,          //注册信息
    
    /** -- Send -- */
    OBJ_InstanceType_Login = 1905,                      //登录包
    OBJ_InstanceType_Login_Register = 1793,             //注册包
};

@interface SCAgreementType : NSObject

@end
