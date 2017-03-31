//
//  Vector.m
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCVectorBase.h"

#import "ObjSerializerTool.h"

#import <objc/runtime.h>
@implementation SCVectorBase
@end
@interface SCMapBase (){
    //    uint16_t _allNumber;
}

@end
@implementation SCMapBase

/** 反序列化 */
- (instancetype)reserializeObj:(NSData *)data{
    ObjSerializerTool *objSerializerTool;
    if (data) {
        //        _allNumber = allNumber;
        // data 不为空
        objSerializerTool = [ObjSerializerTool new];
        objSerializerTool.objData = data;
    }else{
        // 缓存 data 也为空
        return nil;
    }
    //得到个数allNumber
    uint16_t tmp;
    // 字符描述占的范围
    NSRange agreementRange = NSMakeRange(0, sizeof(uint16_t));
    // 获取字符描述内容
    [data getBytes:&tmp range:agreementRange];
    
    NSUInteger allNumber = tmp;
    //获取类的所有成员变量
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    //个数循环
    for (int setNub = 0; setNub < allNumber; setNub++) {
        u_int count;
        objc_property_t *properties  = class_copyPropertyList([self class], &count);
        
        NSString *dicKey = @"";
        id dicValue = nil;
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
            
            // 得到这个成员变量的值
            id value = [objSerializerTool nextValueWithRegulation:nil];
            
            if (!value) {
                // 返回值为空
                continue;
            }
            // 解析属性
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            //判断属性名
            if ([propertyName isEqualToString:@"key"]) {
                dicKey = value;
            }else{
                dicValue = value;
            }
            // 为当前实例赋值
//            [self setValue:value forKey:propertyName];
        }
        [mDic setValue:dicValue forKey:dicKey];

        free(properties);
    }
    return [mDic mutableCopy];
}

/** 序列化 */
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
        
        //拼接
//        if (![objSerializerTool appendDataForValue:value andType:type andRegulation:nil]) {
//            // 如果拼接不成功
//            free(properties);
//            return nil;
//        }
    }
    free(properties);
    return objSerializerTool.objData;
}

-(NSUInteger)count{
    return super.count;
}
- (id)objectForKey:(id)aKey{
    return [super objectForKey:aKey];
}
- (NSEnumerator *)keyEnumerator{
    return [super keyEnumerator];
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
@end
