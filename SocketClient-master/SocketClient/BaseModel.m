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
}
@end
@implementation BaseModel

#pragma mark - Interface (接口)
// 反序列化
- (instancetype)reserializeObj:(NSData *)data{
    ObjSerializerTool *objSerializerTool;
    if (data) {
        // data 不为空
        objSerializerTool = [ObjSerializerTool new];
        objSerializerTool.objData = data;
    }else{
        // 缓存 data 也为空
        return nil;
    }
    
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class], &count);
    //获取类的所有成员变量
    
    // 遍历所有属性
    for (int i = 0; i < count; i++) {
        //得到单个的成员变量
        objc_property_t property = properties[i];// 变量名
        
        // 得到这个成员变量的类型
        u_int attCount;
        objc_property_attribute_t *attList = property_copyAttributeList(property, &attCount);
        const char *type = attList[0].value;
        
        if (![objSerializerTool hasNext]) {
            // 如果没有下一个
            break;
        }
        // 获得变量名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
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
        id value = [objSerializerTool nextValueWithType:type andRegulation:regulation];
        
        if (!value) {
            // 返回值为空
            continue;
        }
        
        // 为当前实例赋值
        [self setValue:value forKey:propertyName];
    }
    _length = objSerializerTool.getLength;
    free(properties);
    return self;
}

/**
 序列化
 
 @return 序列化之后的二进制流
 */
- (NSData *)serializeObj{
    ObjSerializerTool *objSerializerTool = [ObjSerializerTool new];
    
    u_int count;
    objc_property_t * properties  = class_copyPropertyList([self class], &count);
    
    // 遍历所有属性
    for (int i=0; i<count; i++) {
        //得到单个的成员变量
        objc_property_t property = properties[i];// 变量名
        // 解析属性
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        // 得到这个成员变量的值
        id value = [self valueForKey:propertyName];
        
        if (!value) {
            // 返回值不为空
            continue;
        }
        
        // 得到这个成员变量的类型
        u_int attCount;
        objc_property_attribute_t *attList = property_copyAttributeList(property, &attCount);
        const char *type = attList[0].value;
        
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
        if (![objSerializerTool appendDataForValue:value andType:type andRegulation:regulation]) {
            // 如果拼接不成功
            free(properties);
            return nil;
        }
    }
    free(properties);
    return objSerializerTool.objData;
}

- (NSDictionary *)getRegulation{
    return nil;
}
- (NSUInteger)returnModelLength{
    return _length;
}
#pragma mark - ModelDelegate (ModelDelegate代理)
- (instancetype)initWithData:(NSData *)data{
    if (self = [super init]) {
        [self reserializeObj:data];
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
