//
//  RegisterModel.m
//  SocketClient
//
//  Created by Allen on 2017/3/9.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "RegisterModel.h"

#import "EncryptionModel.h"
#import "MsgCenterSystemSecret.h"

#include <stdarg.h>
#include <string>

typedef struct{
    int16_t uOpTepy;
    int16_t uAgreementID;
    int8_t eRegistType;//注册类型
    char *sAccount;//账号
    int32_t uPasscode;//密码
    int8_t ePlatform;//系统枚举值
    char  *sPlatformVer;//系统版本号
    char  *sModel;//手机型号
    int16_t nGameVer;//游戏版本号
    char  *sIP;//游戏IP
    char  *sChannel;//渠道
    int8_t bAutoRegist;//若不存在账号则自动注册
    int32_t uHashCode;//哈希编码
    int32_t uPlayerID;//玩家ID
    char  *sChannelRelease;//发布渠道
    char  *vChannnelArg;//渠道参数
    
}RegisterInfo;
@implementation RegisterModel{
    RegisterInfo model;
}


#pragma mark - 初始化
+ (instancetype)getRegisterData{
    return [[RegisterModel alloc]init];
}
- (instancetype)init{
    if (self = [super init]) {
        model.uOpTepy = 1;
        model.uAgreementID=1905;
        model.eRegistType=1;//注册类型
        char sAccount[32] = "72827k4qtts6x36fik64";
        model.sAccount = sAccount;//账号
        
        model.uPasscode=1249063034;//密码
        model.ePlatform=3;//系统枚举值
        char sPlatformVer[32] = "Windows 7";
        model.sPlatformVer = sPlatformVer;//系统版本号
        
        char sModel[32] = "Windows";
        model.sModel = sModel;//手机型号
        model.nGameVer=9;//游戏版本号
        
        char sIP[32] = "1";
        model.sIP = sIP;//游戏IP
        
        char sChannel[32] = "WINDOWS";
        model.sChannel = sChannel;//渠道
        model.bAutoRegist=1;//若不存在账号则自动注册
//        model.uHashCode=1;//哈希编码
//        model.uPlayerID=1;//玩家ID
//        model.sChannelRelease=@"1";//发布渠道
        
        char vChannnelArg[32] = "";
        model.vChannnelArg = vChannnelArg;//渠道参数
    }
    return self;
}

- (NSData *)getResultDataWithSecret:(MsgCenterSystemSecret *)secret{
    char *pBuffer;// "拼接过的字符串"
    uint length;
    /* todo: 拼接过的字符串,获取长度 */
    
    sprintf(pBuffer,"%zi%s%s%zi%zi%s%s%zi%s%zi%s", model.eRegistType, model.sAccount, model.sChannel, model.uPasscode, model.ePlatform, model.sPlatformVer,model.sModel,model.nGameVer,model.sIP,model.bAutoRegist,model.vChannnelArg);
    
//    std::snprintf(pBuffer, sizeof(pBuffer), "%zi%s%s%zi%zi%s%s%zi%s%zi%s", model.eRegistType, model.sAccount, model.sChannel, model.uPasscode, model.ePlatform, model.sPlatformVer,model.sModel,model.nGameVer,model.sIP,model.bAutoRegist,model.vChannnelArg);
    length = (int)strlen(pBuffer);
    
//    NSString *str = [NSString stringWithFormat:@"%zi%@%@%zi%zi%@%@%zi%@%zi%@", regModel.eRegistType, regModel.sAccount, regModel.sChannel, regModel.uPasscode, regModel.ePlatform, regModel.sPlatformVer,regModel.sModel,regModel.nGameVer,regModel.sIP,regModel.bAutoRegist,regModel.vChannnelArg];
    
    [EncryptionModel getEncryptionForKey:secret.uSecretKey andBuffer:pBuffer andLength:length];
    
    /* todo : 在pBuffer前拼接包头 */
//  secret.uAgreementID + pBuffer
    sprintf(pBuffer, "%zi%s", model.uAgreementID, pBuffer);
    
    length = (int)strlen(pBuffer);
    
    return [NSData dataWithBytes:&pBuffer length:sizeof(pBuffer)];
}

#pragma mark - Private
- (void)setUOpTepy:(NSUInteger)uOpTepy{
    model.uOpTepy = (int16_t)uOpTepy;
}
-(void)setUAgreementID:(NSUInteger)uAgreementID{
    model.uAgreementID = (int16_t)uAgreementID;
}
-(void)setERegistType:(NSUInteger)eRegistType{
    model.eRegistType = (int8_t)eRegistType;
}
- (void)setSAccount:(NSString *)sAccount{
    model.sAccount = (char *)[sAccount UTF8String];
}
- (void)setUPasscode:(NSUInteger)uPasscode{
    model.uPasscode = (int32_t)uPasscode;
}
//int8_t ePlatform;//系统枚举值
- (void)setEPlatform:(NSUInteger)ePlatform{
    model.ePlatform = (int8_t)ePlatform;
}
//std::string  *sPlatformVer;//系统版本号
-(void)setSPlatformVer:(NSString *)sPlatformVer{
    model.sPlatformVer = (char *)[sPlatformVer UTF8String];
}
//std::string  *sModel;//手机型号
- (void)setSModel:(NSString *)sModel{
    model.sModel = (char *)[sModel UTF8String];
}
//int16_t nGameVer;//游戏版本号
- (void)setNGameVer:(NSUInteger)nGameVer{
    model.nGameVer = (int8_t)nGameVer;
}
//std::string  *sIP;//游戏IP
-(void)setSIP:(NSString *)sIP{
    model.sIP = (char *)[sIP UTF8String];
}
//std::string  *sChannel;//渠道
-(void)setSChannel:(NSString *)sChannel{
    model.sChannel = (char *)[sChannel UTF8String];
}
//int8_t bAutoRegist;//若不存在账号则自动注册
- (void)setBAutoRegist:(NSUInteger)bAutoRegist{
    model.bAutoRegist = (int8_t)bAutoRegist;
}
//int32_t uHashCode;//哈希编码
- (void)setUHashCode:(NSUInteger)uHashCode{
    model.uHashCode = (int8_t)uHashCode;
}
//int32_t uPlayerID;//玩家ID
- (void)setUPlayerID:(NSUInteger)uPlayerID{
    model.uPlayerID = (int8_t)uPlayerID;
}
//std::string  *sChannelRelease;//发布渠道
-(void)setSChannelRelease:(NSString *)sChannelRelease{
    model.sChannelRelease = (char *)[sChannelRelease UTF8String];
}
//std::string  *vChannnelArg;//渠道参数
- (void)setVChannnelArg:(NSString *)vChannnelArg{
    model.vChannnelArg = (char *)[vChannnelArg UTF8String];
}
@end
@implementation RegisterInformationModel

@end
