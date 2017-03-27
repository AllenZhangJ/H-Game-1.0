//
//  XAccountInfo.h
//  SocketClient
//
//  Created by you hao on 2017/3/27.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseModel.h"

@interface XAccountInfo : BaseModel

@property (nonatomic, assign) uint32_t uPlayerID;   //玩家ID

@property (nonatomic, assign) uint8_t nRights;      //权限

@property (nonatomic, assign) uint32_t uMoney;      //平台币

@property (nonatomic, assign) uint64_t uProcessTime;//更新时间

@end
