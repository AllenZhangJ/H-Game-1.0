//
//  DataCenter.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Allen. All rights reserved.
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
#import "SCRegistReq.h"


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
            MsgSecretTest *secret = [[MsgSecretTest alloc]initWithData:obj_Data andAgreementID:_uAgreementID];
            /** 唯一需要存Key */
            _uScretKey = secret.uSecretKey;
            return secret;
        }
            break;
        case OBJ_InstanceType_LoginMsg:{

            SCLogInMsg *loginMsg;
            if ([EncryptionModel get_C_DecodeForKey:_uScretKey andBuffer:[obj_Data bytes] andLength:obj_Data.length])
            {
                loginMsg = [[SCLogInMsg alloc]initWithData:obj_Data andAgreementID:_uAgreementID];
            }else{
                loginMsg = nil;
            }
            return loginMsg;
        }
            break;
        case OBJ_InstanceType_MsgCenterLoginRep:{

            SCMsgCenterLoginRep *msgCenterRep;
            if ([EncryptionModel get_C_DecodeForKey:_uScretKey andBuffer:[obj_Data bytes] andLength:obj_Data.length]) {
                msgCenterRep = [[SCMsgCenterLoginRep alloc]initWithData:obj_Data andAgreementID:_uAgreementID];
            }else{
                msgCenterRep = nil;
            }
            return msgCenterRep;
        }
            break;
        case OBJ_InstanceType_MsgCenterAccountNtf:{
            SCMsgCenterAccountNtf *msgCenterAccountNtf;

            if ([EncryptionModel get_C_DecodeForKey:_uScretKey andBuffer:[obj_Data bytes] andLength:obj_Data.length]) {
                msgCenterAccountNtf = [[SCMsgCenterAccountNtf alloc]initWithData:obj_Data andAgreementID:_uAgreementID];
            }else{
                msgCenterAccountNtf = nil;
            }
            
            return msgCenterAccountNtf;
        }
            break;
        case OBJ_InstanceType_MSGCenterRegister:{

            SCRegistReq *msgCenterRegistRep;
            if([EncryptionModel get_C_DecodeForKey:_uScretKey andBuffer:[obj_Data bytes] andLength:obj_Data.length]){
                 msgCenterRegistRep = [[SCRegistReq alloc]initWithData:obj_Data andAgreementID:_uAgreementID];
            }else{
                msgCenterRegistRep = nil;
            }
            return msgCenterRegistRep;
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
    _uAgreementID = [baseModel returnAgreementID];
    
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
        case OBJ_InstanceType_Login_Register:{
            if ([object isKindOfClass:[SCRegistReq class]]) {
                instance_Data = [((SCRegistReq *)object) toData];
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

    NSData *instance ;
    
    if ([EncryptionModel get_C_EncryptionForKey:_uScretKey andBuffer:[instance_Data bytes] andLength:instance_Data.length]) {
        instance = instance_Data;
    }else{
        instance = nil;
    }
    
    if (instance) {
        [mutableData appendData:instance];
        return [mutableData copy];
    }
    return nil;
}

@end
