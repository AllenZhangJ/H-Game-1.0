//
//  SCBaseButton.m
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCBaseButton.h"

@implementation SCBaseButton

- (id)initWithButtonStyle:(SCButtonStyle )style{
    if (self = [super init]) {
        switch (style) {
            case SCButtonStyleTransparent:{
                [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
                [self.titleLabel setTextColor:[UIColor colorWithWhite:0 alpha:0]];
            }
                break;
            case SCButtonStyleMassToneAttune:{
                [self setBackgroundColor:kMassToneAttuneColor];
                [self.titleLabel setTextColor:kViceTonalColor];
            }
                break;
            case SCButtonStyleViceTonal:{
                [self setBackgroundColor:kViceTonalColor];
                [self.titleLabel setTextColor:kMassToneAttuneColor];
            }
                break;
            default:
                break;
        }
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}
@end
