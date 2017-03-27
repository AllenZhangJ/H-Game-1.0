//
//  DataCenter.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "DataCenter.h"

//Inside Warehouse
#import <objc/runtime.h>

//model
#import "MsgSecret.h"
#import "MsgSecretTest.h"
#import "SCLogIn.h"
#import "SCLogInMsg.h"
#import "SCMsgCenterLoginRep.h"
#import "SCMsgCenterAccountNtf.h"

//Tool
#import "ObjSerializerTool.h"
#import "EncryptionModel.h"

static NSUInteger kDataCenterAgreementLength = 4;
//Shared
static DataCenter *dataCenter = nil;

@interface DataCenter (){
    uint32_t _uAgreementID;
    
    uint32_t _uScretKey;
}

@end

@implementation DataCenter

#pragma mark - Shared
+(DataCenter *)sharedManager{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        if(!dataCenter) dataCenter = [[DataCenter alloc]init];
    } );
    return dataCenter;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!dataCenter) {
            dataCenter = [super allocWithZone:zone];
            return dataCenter;
        }
        return nil;
    }
}

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
    NSLog(@"AgreementID:%u", _uAgreementID);
    // 获取具体数据的 Data
    NSRange objRange = NSMakeRange(kDataCenterAgreementLength, data.length - kDataCenterAgreementLength);
    NSData *obj_Data = [data subdataWithRange:objRange];
    
    //选择SubModel
    switch (_uAgreementID) {
        case OBJ_InstanceType_MsgSecretTest:{//测试
            MsgSecretTest *secret = [[MsgSecretTest alloc]initWithData:obj_Data];
            secret.uAgreementID = _uAgreementID;
            /** 唯一需要存Key */
            _uScretKey = secret.uSecretKey;
            return secret;
        }
            break;
        case OBJ_InstanceType_LoginMsg:{
            /** 解密 */
            NSData *decodeData = [EncryptionModel getDecodeForKey:_uScretKey andBuffer:obj_Data andLength:obj_Data.length];
            SCLogInMsg *loginMsg = [[SCLogInMsg alloc]initWithData:decodeData];
            loginMsg.uAgreementID = _uAgreementID;
            return loginMsg;
        }
            break;
        case OBJ_InstanceType_MsgCenterLoginRep:{
            /** 解密 */
            NSData *decodeData = [EncryptionModel getDecodeForKey:_uScretKey andBuffer:obj_Data andLength:obj_Data.length];
            SCMsgCenterLoginRep *msgCenterRep = [[SCMsgCenterLoginRep alloc]initWithData:decodeData];
            msgCenterRep.uAgreementID = _uAgreementID;
            return msgCenterRep;
        }
            break;
        case OBJ_InstanceType_MsgCenterAccountNtf:{
            NSData *decodeData = [EncryptionModel getDecodeForKey:_uScretKey andBuffer:obj_Data andLength:obj_Data.length];
            SCMsgCenterAccountNtf *msgCenterAccountNtf = [[SCMsgCenterAccountNtf alloc]initWithData:decodeData];
            msgCenterAccountNtf.uAgreementID = _uAgreementID;
            return msgCenterAccountNtf;
        }
            break;
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
        case OBJ_InstanceType_MsgSecretTest:{//测试
            if ([object isKindOfClass:[MsgSecretTest class]]) {
                instance_Data = [((MsgSecretTest *)object) toData];
            }
        }
            break;
        case OBJ_InstanceType_Login:{
            if ([object isKindOfClass:[SCLogIn class]]) {
                instance_Data = [((SCLogIn *)object) toData];
            }
        }
            break;
        default:{
            return instance_Data;
        }
            break;
    }
    
    if (!instance_Data) return instance_Data;
    
    // 拼接包头 Data 跟数据 Data
    NSMutableData *mutableData = [NSMutableData data];
    
    NSData *agreement_Data = [ObjPacketHeader returnDataForPacketLength:instance_Data.length andpacketAgreementID:_uAgreementID];
    [mutableData appendData:agreement_Data];
    
    NSData *instance = [EncryptionModel getEncryptionForKey:_uScretKey andBuffer:instance_Data andLength:instance_Data.length];
    if (instance) {
        [mutableData appendData:instance];
        return [mutableData copy];
    }
    return nil;
}

@end
