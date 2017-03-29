//
//  ViewController.m
//  SocketClient
//
//  Created by Architray on 13/03/17.
//  Copyright © 2017 Allen. All rights reserved.
//

#import "ViewController.h"

#import "SCLoginService.h"

@interface ViewController ()<SCLoginServiceDelegate>
@property (nonatomic, strong) SCLoginService *service;

@property (weak, nonatomic) IBOutlet UILabel *uPlayerID;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation ViewController

#pragma mark - SCLoginServiceDelegate
- (void)receiveForServiceType:(NSString *)type{
    [self.typeLabel setHidden:NO];
    [self.typeLabel setText:type];
}

-(void)receiveForServiceUName:(NSNumber *)uName andRights:(NSNumber *)rights andMoney:(NSNumber *)money{
    [self.uPlayerID setHidden:NO];
    [self.moneyLabel setHidden:NO];
    [self.uPlayerID setText:uName.stringValue];
    [self.moneyLabel setText:money.stringValue];
}

#pragma mark - Action
//发送消息
- (IBAction)sendMessageAction:(id)sender {
    [self.service loginServerForAccount:@"qqqqqq" andPasscode:@"1835900736"];
}

#pragma mark - Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.uPlayerID setHidden:YES];
    [self.typeLabel setHidden:YES];
    [self.moneyLabel setHidden:YES];
}

- (SCLoginService *)service{
    if (!_service) {
        _service = [[SCLoginService alloc]init];
        _service.loginServiceDelegate = self;
    }
    return _service;
}
@end
