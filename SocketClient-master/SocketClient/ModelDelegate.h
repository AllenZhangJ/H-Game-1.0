//
//  ModelDelegate.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelDelegate <NSObject>

/**
 用 data 初始化
 
 @param data 初始化 Data
 @return 实例
 */
- (instancetype)initWithData:(NSData *)data;
/**
 转换成 data
 
 @return  转换后的 data
 */
- (NSData *)toData;

@optional

@end