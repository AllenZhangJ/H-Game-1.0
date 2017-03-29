//
//  SCServiceCenter.h
//  SocketClient
//
//  Created by you hao on 2017/3/28.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SCLoginServiceDelegate <NSObject>

@optional
/** 是否连上服务器 */
- (void)whetherOnTheServer:(BOOL)isOnTheServer;

/** 状态 */
- (void)receiveForServiceType:(NSString *)type;

/**
 得到用户名、权限、金币
 */
- (void)receiveForServiceUName:(NSNumber *)uName andRights:(NSNumber *)rights andMoney:(NSNumber *)money;

@end

@interface SCLoginService : NSObject

/** Delegate */
@property (nonatomic, weak) id<SCLoginServiceDelegate> loginServiceDelegate;

/** server */
//Login
- (void)loginServerForAccount:(NSString *)account andPasscode:(NSString *)passcode;
//
- (BOOL)connectService;
@end
