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
    /** 图片切换 */
    SCButtonStyleToggleIconTypes,
};
typedef void (^ReturnTouchBlock)(BOOL isHighligh);
@interface SCBaseButton : UIButton

/** SCButtonStyleToggleIconTypes */
@property (nonatomic, copy) ReturnTouchBlock returnTouchBlock;
- (id)initWithImageButtonForeground:(NSString *)foregroundImage andHighlight:(NSString *)highlightImage returnTouchAction:(ReturnTouchBlock)block;


- (id)initWithButtonStyle:(SCButtonStyle )style returnTouchAction:(ReturnTouchBlock)block;

- (void)setTitle:(NSString *)title;
@end
