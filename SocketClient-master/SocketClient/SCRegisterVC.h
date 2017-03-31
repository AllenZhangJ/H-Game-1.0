//
//  SCRegisterVC.h
//  SocketClient
//
//  Created by you hao on 2017/3/30.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ReturnTextBlock)(NSString *userName, NSString *passcode);
@interface SCRegisterVC : BaseViewController

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
