//
//  SCMsgCenterAccountNtf.h
//  SocketClient
//
//  Created by you hao on 2017/3/27.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseModel.h"

#import "XAccountInfo.h"

typedef NS_ENUM(uint8_t, OP_MSGCENTER_ACCOUNT_PLAYER){
    OP_MSG_ACCOUNT_INVAILD = 0,
    
    OP_MSG_ACCOUNT_INFO,
    OP_MSG_ACCOUNT_MONEY,
    OP_MSG_ACCOUNT_RIGHTS,
    OP_MSG_ACCOUNT_MAX
};
@interface SCMsgCenterAccountNtf : BaseModel

@property (nonatomic, assign) OP_MSGCENTER_ACCOUNT_PLAYER uOpType;

@property (nonatomic, strong) XAccountInfo *xAccountInfo;

@property (nonatomic, assign) uint32_t uHashCode;
@end
