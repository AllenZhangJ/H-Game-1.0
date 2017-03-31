//
//  DataCenter.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>

//Model
#import "SCRegistReq.h"
#import "SCMsgCenterRegistRep.h"
#import "SCLogIn.h"
#import "SCLogInMsg.h"
#import "SCMsgCenterLoginRep.h"
#import "SCMsgCenterAccountNtf.h"
#import "Vernt.h"
#import "MsgSecret.h"
#import "MsgSecretTest.h"

/** Delegate */
#import "ModelDelegate.h"

/** ENUM */
#import "SCAgreementType.h"

@interface DataCenter : NSObject

/** shared */
+ (DataCenter *)sharedManager;

- (id<ModelDelegate>)objFromData:(NSData *) data;

- (NSData *)dataFromInstance:(id<ModelDelegate>) instance;

@end
