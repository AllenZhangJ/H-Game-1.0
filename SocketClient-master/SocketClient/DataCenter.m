//
//  DataCenter.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "DataCenter.h"

//内库
#import <objc/runtime.h>

//model
#import "MsgSecret.h"
#import "MsgSecretTest.h"
#import "SCLogIn.h"
#import "SCLogInMsg.h"

//工具
#import "ObjSerializerTool.h"
#import "EncryptionModel.h"

static NSUInteger kDataCenterAgreementLength = 4;



@interface DataCenter (){
    uint32_t _uAgreementID;
    
    uint32_t _uScretKey;
}

@end

@implementation DataCenter

#pragma mark - Interface
- (id<ModelDelegate>)objFromData:(NSData *)data{
    return [self private_getInstanceFromData:data];
}

- (NSData *)dataFromInstance:(id<ModelDelegate>)object{
    return [self private_dataFromInstance:object];
}

#pragma mark - Private
- (id<ModelDelegate>)private_getInstanceFromData:(NSData *)data{
    ObjPacketHeader *packetHeader = [ObjPacketHeader returnPacketHeaderForData:data];
    _uAgreementID = packetHeader.packetAgreementID;
    
    // 获取具体数据的 Data
    NSRange objRange = NSMakeRange(kDataCenterAgreementLength, data.length - kDataCenterAgreementLength);
    NSData *obj_Data = [data subdataWithRange:objRange];
    
    //选择SubModel
    switch (_uAgreementID) {
        case OBJ_InstanceType_MsgSecret:{
            // 解析
            MsgSecret *secret = [[MsgSecret alloc]initWithData:obj_Data];
            // 记录包头
            secret.uAgreementID = _uAgreementID;
            return secret;
        }
            break;
        case OBJ_InstanceType_MsgSecretTest:{//测试
            MsgSecretTest *secret = [[MsgSecretTest alloc]initWithData:obj_Data];
            secret.uAgreementID = _uAgreementID;
            _uScretKey = secret.uSecretKey;
            return secret;
        }
            break;
        case OBJ_InstanceType_LoginMsg:{
            NSData *decodeData = [EncryptionModel getDecodeForKey:_uScretKey andBuffer:obj_Data andLength:obj_Data.length];
            SCLogInMsg *loginMsg = [[SCLogInMsg alloc]initWithData:decodeData];
            loginMsg.uAgreementID = _uAgreementID;
        }
        default:{
            return nil;
        }
            break;
    }
}

//
- (NSData *)private_dataFromInstance:(id<ModelDelegate>)object{
    BaseModel *baseModel = object;
    _uAgreementID = baseModel.uAgreementID;
    
    NSData *instance_Data;
    switch (_uAgreementID) {
        case OBJ_InstanceType_MsgSecret:{
            // 再次确认类型是否正确(可以不加)
            if ([object isKindOfClass:[MsgSecret class]]) {
                instance_Data = [((MsgSecret *)object) toData];
            }
        }
            break;
        case OBJ_InstanceType_MsgSecretTest:{//测试
            if ([object isKindOfClass:[MsgSecretTest class]]) {
                instance_Data = [((MsgSecretTest *)object) toData];
            }
        }
            break;
        case OBJ_InstanceType_Login:{
            if ([object isKindOfClass:[SCLogIn class]]) {
                instance_Data = [((SCLogIn *)object) toData];
                //if (!_uAgreementID)_uAgreementID = OBJ_InstanceType_Login;
            }
        }
            break;
        default:{
            // 如果没有找到对应的类
            
            return instance_Data;
        }
            break;
    }
    
    if (!instance_Data) {
        // 如果数据为空
        return instance_Data;
    }
    
    
    
    // 拼接包头 Data 跟数据 Data
    NSMutableData *mutableData = [NSMutableData data];
    
    NSData *agreement_Data = [ObjPacketHeader returnDataForPacketLength:instance_Data.length andpacketAgreementID:_uAgreementID];
    
    [mutableData appendData:agreement_Data];
    
    NSData *instance = [EncryptionModel getEncryptionForKey:_uScretKey andBuffer:instance_Data andLength:instance_Data.length];
    if (instance) {
        [mutableData appendData:instance];
        NSLog(@"——————Encryption Data: %@", mutableData);
        
//        NSRange objRange = NSMakeRange(kDataCenterAgreementLength, mutableData.length - kDataCenterAgreementLength);
//        NSData *data_decode = [mutableData subdataWithRange:objRange];
//        NSData *decodeData = [EncryptionModel getDecodeForKey:_uScretKey andBuffer:data_decode andLength:data_decode.length];
//        SCLogIn *login = [[SCLogIn alloc]initWithData:decodeData];
//        NSLog(@"login:%@", login);
        return [mutableData copy];
    }
    return nil;
}

@end
