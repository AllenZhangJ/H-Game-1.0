//
//  SCRegistReq.h
//  SocketClient
//
//  Created by you hao on 2017/3/30.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(uint8_t, OP_REGIST_TYPE){
    OP_REGIST_TYPE_INVALD = 0,
    OP_REGIST_TYPE_PLAYER,
    OP_REGIST_TYPE_MAX,
};
@interface SCRegistReq : BaseModel
@property (nonatomic ,assign) OP_REGIST_TYPE uOpType;
@property (nonatomic ,strong) NSString *sAccount;       //账号
@property (nonatomic ,strong) NSString *sChannel;       //渠道
@property (nonatomic ,assign) uint32_t uPasscode;       //密码
@property (nonatomic ,assign) uint8_t eRegistType;      //注册类型
@property (nonatomic ,assign) uint8_t ePlatform;        //系统枚举值
@property (nonatomic ,strong) NSString *sPlatformVer;   //系统版本号
@property (nonatomic ,strong) NSString *sModel;         //手机型号
@property (nonatomic ,assign) uint16_t nGameVer;        //游戏版本号
@property (nonatomic ,strong) NSString *sAnonymousAccount;//匿名账号
@property (nonatomic ,strong) NSString *sDeviceChannel; //匿名渠道
@property (nonatomic ,strong) NSString *sIP;            //登录IP



@property (nonatomic ,assign) uint16_t uErrCode;
@property (nonatomic ,assign) uint32_t uPlayerID;       //玩家ID
@property (nonatomic ,strong) NSString *sNewAccount;    //账号
@property (nonatomic ,assign) uint32_t uNewPasscode;    //密码
@property (nonatomic ,assign) uint8_t nServerID;
@property (nonatomic ,assign) uint32_t uRights;         //
@property (nonatomic ,assign) uint8_t bAutoRegist;      //自动注册

@end
