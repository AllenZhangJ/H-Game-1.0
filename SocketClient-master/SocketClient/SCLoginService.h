//
//  SCServiceCenter.h
//  SocketClient
//
//  Created by you hao on 2017/3/28.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLoginService : NSObject
/** server */
//登录
- (void)loginServerForAccount:(NSString *)account andPasscode:(NSString *)passcode;


@end
