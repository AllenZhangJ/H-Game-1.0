//
//  BaseModel.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "BaseModel.h"

#import "ObjTypeTool.h"

#import "ObjSerializerTool.h"

#import <objc/runtime.h>

@interface BaseModel (){
    /* TODO: 找机会释放缓存 */
    NSData *_dataCache;
}

@end

@implementation BaseModel

#pragma mark - Interface (接口)
- (void)setData:(NSData *)data{
    _dataCache = data;
}

// 反序列化
- (instancetype)reserializeObj:(NSData *)data{
    if (data) {
        // data 不为空
        _dataCache = data;
    }else if (!_dataCache){
        // 缓存 data 也为空
        return nil;
    }
    
    u_int count;
    objc_property_t * properties  = class_copyPropertyList([self class], &count);
    //获取类的所有成员变量
    Ivar * ivars = class_copyIvarList([self class], &count);
    
    NSUInteger curLocation = 0;// 记录当前解析的位置
    
    // 遍历所有属性
    for (int i=0; i<count; i++) {
        //得到单个的成员变量
        objc_property_t property = properties[i];// 变量名
        Ivar thisIvar = ivars[i];// 用于获取变量类型
        // 解析属性
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        /* TODO: 这里缺少"属性是否存在"的验证,可以不验证 */
        //        SEL setSel = [self creatSetterWithPropertyName:propertyName];
        //        if ([self respondsToSelector:setSel]) {
        //        }
        
        // 得到这个成员变量的类型
        const char *type = ivar_getTypeEncoding(thisIvar);
        //        const char *name = ivar_getName(thisIvar);
        // 得到这个成员变量的值
        id value = [ObjSerializerTool private_valueFromData:_dataCache andAtLocation:&curLocation andPropertyType:type];
        if (!value) {
            // 返回值为空
            continue;
        }
        // 为当前实例赋值
        [self setValue:value forKey:propertyName];
    }
    free(properties);
    free(ivars);
    return self;
}

/**
 序列化
 
 @return 序列化之后的二进制流
 */
- (NSData *)serializeObj{
    /* TODO: 序列化过程 */
    
    if (_dataCache) {
        // _dataCache 不为空
        _dataCache = nil;
    }
    
    u_int count;
    objc_property_t * properties  = class_copyPropertyList([self class], &count);
    //获取类的所有成员变量
    Ivar * ivars = class_copyIvarList([self class], &count);
    
    NSMutableData *mutabledata = [NSMutableData data];
    // 遍历所有属性
    for (int i=0; i<count; i++) {
        //得到单个的成员变量
        objc_property_t property = properties[i];// 变量名
        Ivar thisIvar = ivars[i];// 用于获取变量类型
        // 解析属性
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        // 得到这个成员变量的类型
        const char *type = ivar_getTypeEncoding(thisIvar);
        //        const char *name = ivar_getName(thisIvar);
        // 得到这个成员变量的值
        id value = [self valueForKey:propertyName];
        
        if (!value) {
            // 返回值不为空
            continue;
        }
        
        //拼接
        NSData *valueData = [ObjSerializerTool private_valueJoinDataAtValue:value Type:type];
        
        //判断拼接后的Data
        if (!valueData) {
            //拼接为空
            continue;
        }else{
            //拼接包体
            [mutabledata appendData:valueData];
        }
    }

    return [mutabledata mutableCopy];
}

#pragma mark - ModelDelegate (ModelDelegate代理)
- (instancetype)initWithData:(NSData *)data{
    if (self = [super init]) {
        _dataCache = data;
    }
    return self;
}

- (NSData *)toData{
    return nil;
}

#pragma mark - Private (私有方法)


@end
