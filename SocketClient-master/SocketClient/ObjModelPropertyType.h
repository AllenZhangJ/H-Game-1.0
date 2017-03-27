//
//  ObjModelPropertyType.h
//  SocketClient
//
//  Created by you hao on 2017/3/22.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, BaseModelPropertyType) {
    //***CataloguelistingPlist加入***//
    BaseModelPropertyType_Error = -1,
    BaseModelPropertyType_UInt8 = 1,
    BaseModelPropertyType_UInt16,
    BaseModelPropertyType_UInt32,
    BaseModelPropertyType_UInt64,
    BaseModelPropertyType_NSString,
    BaseModelPropertyType_NSDictionary,
    BaseModelPropertyType_NSArray,
    //结构体类型
    BaseModelPropertyType_XTest,
    BaseModelPropertyType_XAccountInfo,
};


extern NSString *const ObjTypeUInt8;
extern NSString *const ObjTypeUInt16;
extern NSString *const ObjTypeUInt32;
extern NSString *const ObjTypeUInt64;
extern NSString *const ObjTypeNSString;
extern NSString *const ObjTypeNSDictionary;
extern NSString *const ObjTypeNSArray;
//结构体类型
extern NSString *const ObjTypeXTest;
extern NSString *const ObjTypeXAccountInfo;

@interface ObjModelPropertyType : NSObject

@end
