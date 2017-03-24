//
//  SClogIn.h
//  SocketClient
//
//  Created by you hao on 2017/3/24.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(uint8_t, OP_LOGIN_TYPE){
    OP_LOGIN_INVAILD = 0,
    OP_LOGIN_LOGIN_PLAYER,
    OP_LOGIN_LOGINCHECK_PLAYER,
    OP_LOGIN_MAX,
};
@interface SCLogIn : BaseModel
@property (nonatomic ,assign) OP_LOGIN_TYPE opType;
@property (nonatomic ,assign) uint8_t eRegistType;//注册类型
@property (nonatomic ,strong) NSString *sAccount;//账号
@property (nonatomic ,strong) NSString *sChannel;//渠道
@property (nonatomic ,assign) uint32_t uPasscode;//密码
@property (nonatomic ,assign) uint8_t ePlatform;//系统枚举值
@property (nonatomic ,strong) NSString *sPlatformVer;//系统版本号
@property (nonatomic ,strong) NSString *sModel;//手机型号
@property (nonatomic ,assign) uint16_t nGameVer;//游戏版本号
@property (nonatomic ,strong) NSString *sIP;//游戏IP
@property (nonatomic ,assign) uint8_t bAutoRegist;//若不存在账号则自动注册
@property (nonatomic ,strong) NSDictionary *vChannnelArg;//渠道参数



//@property (nonatomic ,assign) uint32_t uHashCode;//哈希编码
//@property (nonatomic ,assign) uint32_t uPlayerID;//玩家ID

//@property (nonatomic ,strong) NSString *sChannelRelease;//发布渠道

@end
