//
//  SCBaseLabel.m
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCBaseLabel.h"

@implementation SCBaseLabel

- (id)initWithLabelStyle:(SCLabelStyle )style{
    if (self = [super init]) {
        [self setTextAlignment:NSTextAlignmentCenter];
        switch (style) {
            case LabelStyleH1:{
                [self setFont:[UIFont systemFontOfSize:28]];
            }
                break;
            case LabelStyleH2:{
                [self setFont:[UIFont systemFontOfSize:20]];
            }
                break;
            case LabelStyleH3:{
                [self setFont:[UIFont systemFontOfSize:16]];
            }
            default:
                break;
        }
    }
    return self;
}

@end
