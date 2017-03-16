//
//  ViewController.m
//  SocketClient
//
//  Created by Edward on 16/6/24.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "ViewController.h"

#import "GCDAsyncSocket.h"
#import "LSUDPDataDetail.h"

#import "DataCenter.h"
#import "MsgSecret.h"
#import "MsgSecretTest.h"
#import "Vernt.h"
#import "RegisterModel.h"
#import "MsgCenterSystemSecret.h"


#define URLstr = @"hydemo.hao-games.com"
#define LANURLstr = @"192.168.1.139"
#define LANURLstr_text = @"192.168.1.138"
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showMessageTF;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

//客户端socket
@property (nonatomic) GCDAsyncSocket *clinetSocket;

@property (nonatomic, strong) MsgSecret *data_obj;
//测试
@property (nonatomic, strong) MsgSecretTest *dataTest_obj;

@property (nonatomic, strong) MsgCenterSystemSecret *secret_obj;

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
    self.dataTest_obj = [[DataCenter alloc]objFromData:data];

    NSLog(@"dataTest_obj NSData:%@\n\
          ---------\n\
          uAssID:%u,\n\
          uScretKey:%u,\n\
          uTimeNow:%u,\n\
          u8Test:%zi,\n\
          u16Test:%zi,\n\
          sTest:%@",
          data,
          self.dataTest_obj.uAssID,
          self.dataTest_obj.uSecretKey,
          self.dataTest_obj.uTimeNow,
          self.dataTest_obj.u8Test,
          self.dataTest_obj.u16Test,
          self.dataTest_obj.sTest);

//    self.data_obj = [[DataCenter alloc]objFromData:data];
//    NSLog(@"----------\n\
//          tag=%ld,\n\
//          uAssID:%u,\n\
//          uSecretKey:%u,\n\
//          uTimeNow:%u,\n\
//          hello",
//          tag,
//          self.data_obj.uAssID,
//          self.data_obj.uSecretKey,
//          self.data_obj.uTimeNow);
    
//    self.secret_obj = [[MsgCenterSystemSecret alloc]initWithData:data];
//    NSLog(@"tag=%ld,uAssID:%ld,uSecretKey:%u,uTimeNow:%ld,u8Test:%zi", tag, self.secret_obj.uAssID, self.secret_obj.uSecretKey, self.secret_obj.uTimeNow,self.secret_obj.u8Test);
    
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
    [self.sendButton setEnabled:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//开始连接
- (IBAction)connectAction:(id)sender {
    //2、连接服务器
    [self.clinetSocket connectToHost:self.addressTF.text onPort:self.portTF.text.integerValue withTimeout:-1 error:nil];
    
    //test
    Vernt *vernt = [Vernt new];
    vernt.vID_8 = 9;
    vernt.vID_16 = 17;
    vernt.vID_32 = 33;
    vernt.vID_64 = 65;
    vernt.vID_string = @"string_string";
    NSLog(@"vernt NSData:%@", [vernt serializeObj]);
    
    Vernt *vernt_2 = [[Vernt alloc]reserializeObj:[vernt serializeObj]];
    NSLog(@"vernt \n\
          ID_8:%u,\n\
          ID_16:%u, \n\
          ID_32:%u,\n\
          ID_64:%llu,\n\
          ID_str:%@",
          vernt_2.vID_8,
          vernt_2.vID_16,
          vernt_2.vID_32,
          vernt_2.vID_64,
          vernt_2.vID_string);
}

//发送消息
- (IBAction)sendMessageAction:(id)sender {
    RegisterModel *regModel = [RegisterModel getRegisterData];
    //withTimeout -1 :无穷大
    
    NSData *data = [regModel getResultDataWithSecret:self.secret_obj];
    //tag： 消息标记
    [self.clinetSocket writeData:data withTimeout:-1 tag:0];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
