//
//  BaseModel.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Allen. All rights reserved.
//

#import "BaseModel.h"

#import "ObjModelPropertyType.h"

#import "ObjSerializerTool.h"

#import <objc/runtime.h>
@interface BaseModel()
{
    NSUInteger _length;
    uint32_t _uAgreementID;// 包头
}
@end
@implementation BaseModel

#pragma mark - Interface (接口)
// 反序列化
- (instancetype)reserializeObj:(NSData *)data andAgreementID:(uint32_t)agreementID{
    ObjSerializerTool *objSerializerTool;
    if (data) {
        // data 不为空
        objSerializerTool = [ObjSerializerTool new];
        objSerializerTool.objData = data;
    }else{
        // 缓存 data 也为空
        return nil;
    }
    _uAgreementID = agreementID;
    
    NSArray *interfaceArray = [[self getInterfaceRegulation] objectForKey:@(_uAgreementID)];
    /** 结构体类型 */
    if (_uAgreementID == 0) {
        interfaceArray = [self getInterfaceRegulation].allValues.firstObject;
    }
    if (!interfaceArray) {
        return nil;
    }
    for (NSInteger i = 0; i < interfaceArray.count; i++) {
        
        NSString *propertyName = interfaceArray[i];
        
        //查找规则
        NSArray *regulation ;
        if ([[self getRegulation] valueForKey:propertyName]) {
            //有
            regulation = [[self getRegulation] valueForKey:propertyName];
        }else{
            //没有
            regulation = nil;
        }
        // 得到这个成员变量的值
        id value = [objSerializerTool nextValueWithRegulation:regulation];
        
        if (!value) {
            // 返回值为空
            continue;
        }
        
        // 为当前实例赋值
        [self setValue:value forKey:propertyName];
    }
    
    _length = objSerializerTool.getLength;
    return self;
}

/**
 序列化
 
 @return 序列化之后的二进制流
 */
- (NSData *)serializeObj{
    ObjSerializerTool *objSerializerTool = [ObjSerializerTool new];
    
    NSArray *interfaceArray = [[self getInterfaceRegulation] objectForKey:@(_uAgreementID)];
    if (!interfaceArray) {
        return nil;
    }
    for (NSInteger i = 0; i < interfaceArray.count; i++) {
        NSString *propertyName = interfaceArray[i];
        // 得到这个成员变量的值
        id value = [self valueForKey:propertyName];
        
        if (!value) {
            // 返回值不为空
            continue;
        }
        
        //查找规则
        NSArray *regulation ;
        if ([[self getRegulation] valueForKey:propertyName]) {
            //有
            regulation = [[self getRegulation] valueForKey:propertyName];
        }else{
            //没有
            regulation = nil;
        }
        
        //拼接
        if (![objSerializerTool appendDataForValue:value andRegulation:regulation]) {
            // 如果拼接不成功
            return nil;
        }
        
    }

    return objSerializerTool.objData;
}

/**
 发送用初始化方法
 */
- (instancetype)initWithSendToAgreementID:(uint32_t)agreementID{
    if (self = [super init]) {
        _uAgreementID = agreementID;
    }
    return self;
}

- (NSDictionary *)getRegulation{
    return nil;
}

- (NSDictionary *)getInterfaceRegulation{
    return nil;
}

- (NSUInteger)returnModelLength{
    return _length;
}
#pragma mark - ModelDelegate (ModelDelegate代理)
- (instancetype)initWithData:(NSData *)data andAgreementID:(uint32_t)agreementID{
    if (self = [super init]) {
        [self reserializeObj:data andAgreementID:agreementID];
    }
    return self;
}

- (NSData *)toData{
    return [self serializeObj];
}

- (uint32_t)returnAgreementID{
    return _uAgreementID;
}
#pragma mark - Private (私有方法)


@end
