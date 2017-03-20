//
//  SCVector.h
//  SocketClient
//
//  Created by you hao on 2017/3/20.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCVectorBase.h"

@interface SCVector : SCVectorBase
@end
@interface SCVectorInt : SCVectorBase
@end
@interface SCVectorString : SCVectorBase
@end
@interface SCMapUInt8UInt16 : SCMapBase
@property (nonatomic, assign) uint8_t key;
@property (nonatomic, assign) uint16_t value;
@end
