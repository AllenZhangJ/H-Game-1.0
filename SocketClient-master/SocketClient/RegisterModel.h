//
//  RegisterModel.h
//  SocketClient
//
//  Created by Allen on 2017/3/9.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MsgCenterSystemSecret;

@interface RegisterModel : NSObject
@property (nonatomic ,assign) NSUInteger uOpTepy;
@property (nonatomic ,assign) NSUInteger uAgreementID;

@property (nonatomic ,assign) NSUInteger eRegistType;//注册类型
@property (nonatomic ,strong) NSString *sAccount;//账号
@property (nonatomic ,assign) NSUInteger uPasscode;//密码
@property (nonatomic ,assign) NSUInteger ePlatform;//系统枚举值
@property (nonatomic ,strong) NSString *sPlatformVer;//系统版本号
@property (nonatomic ,strong) NSString *sModel;//手机型号
@property (nonatomic ,assign) NSUInteger nGameVer;//游戏版本号
@property (nonatomic ,strong) NSString *sIP;//游戏IP
@property (nonatomic ,strong) NSString *sChannel;//渠道
@property (nonatomic ,assign) NSUInteger bAutoRegist;//若不存在账号则自动注册
@property (nonatomic ,assign) NSUInteger uHashCode;//哈希编码
@property (nonatomic ,assign) NSUInteger uPlayerID;//玩家ID
@property (nonatomic ,strong) NSString *sChannelRelease;//发布渠道
@property (nonatomic ,strong) NSString *vChannnelArg;//渠道参数

+ (instancetype)getRegisterData;
//- (BOOL)getEncryptionForKey:(uint32_t)uSecretKey andBuff:(char *)pBuffer andStr:(uint)uLength;
- (NSData *)getResultDataWithSecret:(MsgCenterSystemSecret *)secret;

@end
@interface RegisterInformationModel : NSObject

@end
