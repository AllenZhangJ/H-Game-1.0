//
//  SCBaseTextField.m
//  SocketClient
//
//  Created by you hao on 2017/3/29.
//  Copyright © 2017年 Edward. All rights reserved.
//

#import "SCBaseTextField.h"

@implementation SCBaseTextField

- (id)initWithTextFieldStyle:(SCTextFieldStyle)style{
    if (self = [super init]) {
        switch (style) {
            case SCTextFieldStyleNone:{
            
            }
                break;
            case SCTextFieldStyleInputValidation:{
            
            }
                break;
            case SCTextFieldStyleEmailAddressVerification:{
            
            }
                break;
            case SCTextFieldStylePasscode:{
            
            }
                break;
            default:
                break;
        }
    }
    return self;
}

@end
