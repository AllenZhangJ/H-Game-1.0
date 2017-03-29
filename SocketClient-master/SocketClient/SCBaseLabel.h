//
//  SCBaseLabel.h
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(uint8_t, SCLabelStyle){
    LabelStyleH1,
    LabelStyleH2,
    LabelStyleH3,
};
@interface SCBaseLabel : UILabel

- (id)initWithLabelStyle:(SCLabelStyle )style;

@end
