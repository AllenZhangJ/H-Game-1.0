//
//  SCBaseButton.h
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(uint8_t, SCButtonStyle){
    /** 透明 */
    SCButtonStyleTransparent,
    /** 主色调 */
    SCButtonStyleMassToneAttune,
    /** 副色调 */
    SCButtonStyleViceTonal,
};
@interface SCBaseButton : UIButton
- (id)initWithButtonStyle:(SCButtonStyle )style;
- (void)setTitle:(NSString *)title;
@end
