//
//  SCLogInMsg.h
//  SocketClient
//
//  Created by you hao on 2017/3/24.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(uint8_t, OP_TYPE){
    OP_LOGINMSG_INVAILD = 0,
    OP_LOGINMSG_ERROR,
    OP_LOGINMSG_MAX,
};
@interface SCLogInMsg : BaseModel
@property (nonatomic ,assign) OP_TYPE uOpType;
@property (nonatomic ,assign) uint16_t uErrCode;

@end
