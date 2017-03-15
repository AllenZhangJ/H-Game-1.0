//
//  BaseModel.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "BaseModel.h"

#import "ObjTypeTool.h"

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
        id value = [self private_valueFromDataAtLocation:&curLocation
                                         andPropertyType:type];
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
        NSData *valueData = [self private_valueJoinDataAtValue:value Type:type];
        
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
///** 序列化 拼接 */
- (NSData *)private_valueJoinDataAtValue:(id)value Type:(const char *)propertyType{
    //判断为空
    if (!value) {
        return nil;
    }
    //获取类型
    NSString *stringType =  [NSString stringWithCString:propertyType
                                               encoding:NSUTF8StringEncoding];
    // 获取类型
//    BaseModelPropertyType type = [ObjTypeTool propertyTypeOfProperty:stringType];

    //拼接
    NSData *valueData = [ObjTypeTool getDataFormValue:value forProperty:stringType];
    
    //验证
    if (!valueData) {
        //值为空
        return nil;
    }
    return valueData;
}
/** 反序列化 获得Value */
- (id)private_valueFromDataAtLocation:(NSUInteger *)location andPropertyType:(const char *)propertyType{
    if (!_dataCache) {
        // 如果 data 缓存为空
        return nil;
    }
    
    NSString *stringType =  [NSString stringWithCString:propertyType
                                               encoding:NSUTF8StringEncoding];
    // 获取类型
    BaseModelPropertyType type = [ObjTypeTool propertyTypeOfProperty:stringType];
    
    NSUInteger typeLangth = 0;
    // 判断是否为字符串类型
    if (type == BaseModelPropertyType_NSString) {
//        uint32_t tmp;
//        *location += tmp;
        
        //字符串长度获取
        typeLangth = [ObjTypeTool stringByteNumberFormData:_dataCache];
    }else {
        typeLangth = [ObjTypeTool byteNumberForPropertyType:type];
    }
    //获得长度
    if (type == BaseModelPropertyType_NSString) typeLangth += sizeof(uint32_t);//字符串
    NSRange rangeTmp = NSMakeRange(*location, typeLangth);
    
    // 验证 Range 越界
    if (*location + typeLangth > _dataCache.length) {
        // 越界
        return nil;
    }
    // 更新位置
    *location += typeLangth;
    //获得Value
    id value = [ObjTypeTool getValueFromData:[_dataCache subdataWithRange:rangeTmp]
                                 forProperty:stringType];
    // 判断是否为字符加值
    if (type == BaseModelPropertyType_NSString) {
        uint32_t tmp;
        *location += sizeof(tmp);
    }
    if (!value) {
        // 值为空
        *location -= typeLangth;// 恢复原值
        if (type == BaseModelPropertyType_NSString) {
            uint32_t tmp;
            *location -= tmp;// 恢复原值
        }
        return nil;
    }
    return value;
}

@end
