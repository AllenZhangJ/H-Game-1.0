//
//  MsgCenterLoginRep.h
//  SocketClient
//
//  Created by you hao on 2017/3/27.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(uint8_t, OP_MSGCENTER_LOGIN_PLAYER){
    OP_MSG_LOGIN_INVAILD = 0,
    OP_MSG_LOGIN_PLAYER,
    OP_MSG_MAX,
};
@interface SCMsgCenterLoginRep : BaseModel
@property (nonatomic, assign) OP_MSGCENTER_LOGIN_PLAYER uOpType;
@property (nonatomic, assign) uint16_t uErrCode;
@property (nonatomic, assign) uint32_t uPlayerID;
@property (nonatomic, strong) NSString *sAccount;
@property (nonatomic, assign) uint32_t uHashCode;

@end
