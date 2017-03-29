//
//  SCBaseTextField.h
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(uint8_t, SCTextFieldStyle){
    SCTextFieldStyleNone,
    
    SCTextFieldStyleInputValidation,
    SCTextFieldStyleEmailAddressVerification,
    SCTextFieldStylePasscode,
};
@interface SCBaseTextField : UITextField
- (id)initWithTextFieldStyle:(SCTextFieldStyle)style;
@end
