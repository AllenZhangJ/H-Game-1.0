//
//  ViewController.m
//  SocketClient
//
//  Created by Edward on 16/6/24.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "ViewController.h"

/** 3f */
#import "GCDAsyncSocket.h"
#import "LSUDPDataDetail.h"

/** Model */
#import "DataCenter.h"

/** SubModel */
#import "SCLogIn.h"
#import "SCLogInMsg.h"
#import "SCMsgCenterLoginRep.h"
#import "SCMsgCenterAccountNtf.h"
#import "Vernt.h"
#import "MsgSecret.h"
#import "MsgSecretTest.h"


//#define URLstr = @"hydemo.hao-games.com"

static NSString *const LANURLstr = @"192.168.1.139";
static NSString *const LANURLstr_text = @"192.168.1.138";
static NSString *const LANLJURL = @"192.168.1.140";
static NSString *const URLStr = @"hydemo.hao-games.com";

@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showMessageTF;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

//客户端socket
@property (nonatomic) GCDAsyncSocket *clinetSocket;

@property (nonatomic, strong) MsgSecret *data_obj;
//test
@property (nonatomic, strong) MsgSecretTest *dataTest_obj;

@property (nonatomic, strong) DataCenter *dataCenter;
@end

@implementation ViewController
#pragma mark - GCDAsynSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [self showMessageWithStr:@"链接成功"];
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP ： %@", host]];
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    id objModel = [self.dataCenter objFromData:data];
    if ([[objModel class] isSubclassOfClass:[MsgSecretTest class]]) {
        self.dataTest_obj = objModel;
        
        NSLog(@"——————receive NSData:%@\n\
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
              data,
              self.dataTest_obj.uAssID,
              self.dataTest_obj.uSecretKey,
              self.dataTest_obj.uTimeNow,
              self.dataTest_obj.u8Test,
              self.dataTest_obj.u16Test,
              self.dataTest_obj.sTest,
              self.dataTest_obj.vU8U16Test,
              self.dataTest_obj.vStringTest,
              self.dataTest_obj.vStringIntTest,
              self.dataTest_obj.vStructTest
              );
    }else if ([[objModel class] isSubclassOfClass:[SCLogInMsg class]]){
        SCLogInMsg *loginMsg = objModel;
        NSLog(@"loginMsgOpType:%@", loginMsg.uOpType==1?@"登录错误":@"");
    }else if([[objModel class] isSubclassOfClass:[SCMsgCenterLoginRep class]]){
        SCMsgCenterLoginRep *msgCenterLoginRep = objModel;
        NSLog(@"Download success!\n\
              PlayerID:%u", msgCenterLoginRep.uPlayerID);
    }else if([[objModel class] isSubclassOfClass:[SCMsgCenterAccountNtf class]]){
        SCMsgCenterAccountNtf *msgCenterAccountNtf = objModel;
        NSLog(@"UserInfo\n\
              uPlayerID:%u\n\
              nRights:%hhu\n\
              uMoney:%u\n\
              uProceessTime:%llu", msgCenterAccountNtf.xAccountInfo.uPlayerID,
              msgCenterAccountNtf.xAccountInfo.nRights,
              msgCenterAccountNtf.xAccountInfo.uMoney,
              msgCenterAccountNtf.xAccountInfo.uProcessTime);
    }
    
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
    [self.sendButton setEnabled:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Action
//开始连接
- (IBAction)connectAction:(id)sender {
    //2、连接服务器
    [self.clinetSocket connectToHost:LANURLstr_text onPort:self.portTF.text.integerValue withTimeout:-1 error:nil];
}

//发送消息
- (IBAction)sendMessageAction:(id)sender {
    SCLogIn *login = [[SCLogIn alloc]init];
    login.opType = OP_LOGIN_LOGIN_PLAYER;
    login.eRegistType = 2;
    login.sAccount = @"qqqqqq";
    login.sChannel = @"OFFICIAL";
    login.uPasscode = 1835900736;
    login.ePlatform = 3;
    login.sPlatformVer = @"Windows 8";
    login.sModel = @"Windows";
    login.nGameVer = 0;
    login.sIP = @"";
    login.bAutoRegist = 0;
    login.vChannnelArg = @{};
    login.uAgreementID = OBJ_InstanceType_Login;
    
    
    NSData *ObjdData = [self.dataCenter dataFromInstance:login];
    [self.clinetSocket writeData:ObjdData withTimeout:1 tag:0];
    
    
    //withTimeout -1 :无穷大
    //tag： 消息标记
    
}

//接收消息
- (IBAction)receiveMessageAction:(id)sender {
    [self.clinetSocket readDataWithTimeout:10 tag:0];
}

- (void)showMessageWithStr:(NSString *)str{
    self.showMessageTF.text = [self.showMessageTF.text stringByAppendingFormat:@"%@\n", str];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //1、初始化
    self.clinetSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - load
- (DataCenter *)dataCenter{
    if (!_dataCenter) {
        _dataCenter = [DataCenter sharedManager];
    }
    return _dataCenter;
}
@end
