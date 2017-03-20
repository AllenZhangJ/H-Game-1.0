//
//  ObjTypeTool.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BaseModelPropertyType) {
    //***CataloguelistingPlist加入***
    BaseModelPropertyType_Error = -1,
    BaseModelPropertyType_UInt8 = 1,
    BaseModelPropertyType_UInt16,
    BaseModelPropertyType_UInt32,
    BaseModelPropertyType_UInt64,
    BaseModelPropertyType_NSString,
    BaseModelPropertyType_SCMapUInt8UInt16
};

@interface ObjTypeReturnData : NSObject
@property (nonatomic ,copy) id returnData;
@property (nonatomic ,assign) NSUInteger dataLangth;
+ (id)returnData:(id)returnData andDataLangth:(NSUInteger)dataLangth;
@end



@interface ObjTypeTool : NSObject

/**
 根据传入Data和"类型字符串"获取对应的OC值
 
 @param data Data
 @param property 类型字符串
 @return OC值+长度
 */
+ (ObjTypeReturnData *)getValueFromData:(NSData *)data forProperty:(NSString *)property;

/**
 根据传入类型字符串获取对应的枚举值
 
 @param property 类型字符串
 @return 类型枚举值
 */
+ (BaseModelPropertyType)propertyTypeOfProperty:(NSString *)property;

/** 
 字符描述部分获取长度
 */
+ (NSUInteger)langthByteNumberFormData:(NSData *)data;

/** 
 根据传入类型字符串 获取对应的C值
 */
+ (NSData *)getDataFormValue:(id)value forProperty:(NSString *)property;
@end
