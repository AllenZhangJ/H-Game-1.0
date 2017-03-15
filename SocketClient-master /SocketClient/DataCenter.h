//
//  DataCenter.h
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelDelegate.h"

@interface DataCenter : NSObject

- (id<ModelDelegate>)objFromData:(NSData *) data;

- (NSData *)dataFromInstance:(id<ModelDelegate>) instance;

@end
