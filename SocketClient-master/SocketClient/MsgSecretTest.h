//
//  MsgSecretTest.h
//  SocketClient
//
//  Created by you hao on 2017/3/16.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseModel.h"
#import "SCVector.h"
@interface MsgSecretTest : BaseModel

@property (nonatomic, assign) uint32_t uAssID;
@property (nonatomic, assign) uint32_t uSecretKey;
@property (nonatomic, assign) uint32_t uTimeNow;
@property (nonatomic, assign) uint8_t u8Test;
@property (nonatomic, assign) uint16_t u16Test;
@property (nonatomic, strong) NSString *sTest;
@property (nonatomic, strong) NSDictionary *vU8U16Test;
@property (nonatomic, strong) NSArray *vStringTest;
@property (nonatomic, strong) NSDictionary *vStringIntTest;
@property (nonatomic, strong) NSDictionary *vStructTest;
@end
