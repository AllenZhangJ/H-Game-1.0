//
//  DataCenter.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "DataCenter.h"

#import "MsgSecret.h"
#import "MsgSecretTest.h"
#import <objc/runtime.h>

static NSUInteger kDataCenterAgreementLength = 4;

typedef NS_ENUM(UInt32, OBJ_InstanceType) {
    OBJ_InstanceType_MCSS = 106102800,
    OBJ_InstanceType_MsgSecret = 106102800,// 包头号,对应的类
    OBJ_InstanceType_MsgSecretTest = 106102856,
};

@interface DataCenter (){
    UInt32 _uAgreementID;
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
    
    // 包头占的范围
    NSRange agreementRange = NSMakeRange(0, kDataCenterAgreementLength);
    
    // 获取包头,两个方法都可以
    // 方法1
    [data getBytes:&_uAgreementID range:agreementRange];
    // 方法2
    NSData *agreement_Data = [data subdataWithRange:agreementRange];
    [agreement_Data getBytes:&_uAgreementID length:sizeof(_uAgreementID)];
    
    // 获取具体数据的 Data
    NSRange objRange = NSMakeRange(kDataCenterAgreementLength, data.length - kDataCenterAgreementLength);
    NSData *obj_Data = [data subdataWithRange:objRange];
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
            return secret;
        }
        default:{
            return nil;
        }
            break;
    }
    
    
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:data.length];
//    NSUInteger i = 0;
//    if (data.length > 0)
//    {
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:data.length];
//        NSUInteger i = 0;
//        for (i = 0; i < data.length; i++)
//        {
//            unsigned char byteFromArray = (unsigned char)data.bytes[i];
//            [array addObject:[NSValue valueWithBytes:&byteFromArray
//                                            objCType:@encode(unsigned char)]];
//        }
//        return [NSArray arrayWithArray:array];
//    }
    
//    unsigned char *bytes = [data bytes];
    //如果你要编辑的数据，还有关于NSData的才会这样。
    // Make your array to hold the bytes
//    NSUInteger length = [data length];
//    unsigned char *bytes = malloc( length * sizeof(unsigned char) );
//    // Get the data
//    [data getBytes:bytes length:length];
//    
//    return self;
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
    NSMutableData *mutableData;
    
    NSData *agreement_Data = [NSData dataWithBytes:&_uAgreementID length:sizeof(_uAgreementID)];
    [mutableData appendData:(NSData *)agreement_Data];
    [mutableData appendData:(NSData *)instance_Data];
    
    return [mutableData copy];
}

@end
