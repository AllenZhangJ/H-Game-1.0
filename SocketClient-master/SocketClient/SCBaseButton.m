//
//  SCBaseButton.m
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCBaseButton.h"
@interface SCBaseButton ()
{
    BOOL isHighlight;
}
@end
@implementation SCBaseButton

- (id)initWithButtonStyle:(SCButtonStyle )style returnTouchAction:(ReturnTouchBlock)block{
    if (self = [super init]) {
        self.returnTouchBlock = block;
        isHighlight = NO;
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
            case SCButtonStyleToggleIconTypes:{
                ;
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

- (id)initWithImageButtonForeground:(NSString *)foregroundImage andHighlight:(NSString *)highlightImage returnTouchAction:(ReturnTouchBlock)block{
    isHighlight = NO;
    if (self = [super init]) {
        self.returnTouchBlock = block;
        [self setBackgroundImage:[UIImage imageNamed:foregroundImage] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
        [self setTitle:@""];
    }
    return self;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.returnTouchBlock != nil) {
        self.returnTouchBlock(isHighlight);
        isHighlight = !isHighlight;
    }
    [super touchesEnded:touches withEvent:event];
}
@end
