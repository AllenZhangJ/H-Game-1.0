//
//  Vernt.h
//  SocketClient
//
//  Created by Allen on 2017/3/14.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "BaseModel.h"

@interface Vernt : BaseModel
//测试
@property (nonatomic ,assign) uint32_t vID_32;
@property (nonatomic ,assign) uint64_t vID_64;
@property (nonatomic ,strong) NSString *vID_string;
@end
