//
//  AppDelegate.m
//  SocketClient
//
//  Created by Edward on 16/6/24.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "AppDelegate.h"
#import "ObjSerializerTool.h"

#import "DataCenter.h"
#import "SCSocketConter.h"
@interface AppDelegate ()<SCSocketDelegate>
@property (nonatomic, strong) SCSocketConter *socketConter;
@property (nonatomic, strong) DataCenter *dataCenter;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#warning 异步
    //初始化dataConter
    ObjTypeTool *tool = [ObjTypeTool new];
    //连接服务器
    self.dataCenter = [DataCenter sharedManager];
    self.socketConter = [SCSocketConter sharedManager];
    self.socketConter.socketdelegate = self;
    if ([self.socketConter connectService]) {
#warning 提示连接成功
        NSLog(@"To connect to the server success");
    }else{
#warning 重连
        NSLog(@"Failed to connect to server");
    }
    
    
    
    
    
    return YES;
}
/** 连接成功接收 */
- (void)receiveModelForServiceReadData:(NSData *)data withTag:(long)tag{
    id objModel = [self.dataCenter objFromData:data];
    if ([[objModel class] isSubclassOfClass:[MsgSecretTest class]]) {
        MsgSecretTest *dataTest_obj = objModel;
        NSLog(@"——————receive\n\
              ---------\n\
              uAssID:%u,\n\
              uScretKey:%u,\n\
              uTimeNow:%u,\n\
              u8Test:%d,\n\
              u16Test:%d,\n\
              sTest:%@,\n\
              vU8U16Test:%@,\n\
              vStringTest:%@,\n\
              vStringIntTest:%@,\n\
              vStructTest:%@\n\
              ",
              dataTest_obj.uAssID,
              dataTest_obj.uSecretKey,
              dataTest_obj.uTimeNow,
              dataTest_obj.u8Test,
              dataTest_obj.u16Test,
              dataTest_obj.sTest,
              dataTest_obj.vU8U16Test,
              dataTest_obj.vStringTest,
              dataTest_obj.vStringIntTest,
              dataTest_obj.vStructTest
              );
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
