//
//  MsgSecret.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import "BaseModel.h"

@interface MsgSecret : BaseModel

@property (nonatomic, assign) uint32_t uAssID;
@property (nonatomic, assign) uint32_t uSecretKey;
@property (nonatomic, assign) uint32_t uTimeNow;

@end
