//
//  YDSocketConnectService.m
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import "YDSocketConnectService.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <MJExtension/MJExtension.h>
#import "YDSocketBackData.h"
#import "game_wwj-Swift.h"
#import "YDAlertView.h"

@interface YDSocketConnectService ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *dSocket;

@property (nonatomic, strong) NSTimer *connectTimer;

@property (nonatomic,copy) NSString *machineSn;

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSString *address;

@property (nonatomic,assign) int port;

@property (nonatomic,assign) int type;

@end

@implementation YDSocketConnectService

- (instancetype)initWithMachineSn:(NSString *)machineSn port:(int)port token:(NSString *)token address:(NSString *)address type:(int)type {
    YDSocketConnectService *service = [[YDSocketConnectService alloc] init];
    service.machineSn = machineSn;
    service.token = token;
    service.port = port;
    service.address = address;
    self.type = type;
    [service socketConnect];
    return service;
}

- (void)socketConnect {
    NSLog(@"start connecting");
    //启动服务
    self.dSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("socket_delegate_queue", DISPATCH_QUEUE_CONCURRENT)];
    NSError *error;
    //192.168.0.115   121.36.196.87     123.60.149.177
    //58888           56792
    NSString *address_pro = @"121.36.196.87"; //
    NSInteger port_pro = 58888;//56792
    BOOL connectFlag = [self.dSocket connectToHost:address_pro onPort:port_pro error:&error];
    if(connectFlag) {
        [self addTimer];
        [self.dSocket readDataWithTimeout:- 1 tag:0];
    }       
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"connect----suc");
    // 连接成功开启定时器
    // 连接后,可读取服务端的数据
    NSDictionary *conDic = @{@"cmd":@"conn",
                             @"vmc_no":self.machineSn,
                             @"token":self.token,
                             @"type":[NSString stringWithFormat:@"%d", self.type]
    };
    [self sendMessageData:[conDic mj_JSONString]];
    
    
#if USE_SECURE_CONNECTION
    {
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
        {
            [sock performBlock:^{
                if ([sock enableBackgroundingOnSocket])
                else
            }];
        }
#endif
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
        [settings setObject:@"www.paypal.com"
                     forKey:(NSString *)kCFStreamSSLPeerName];
        [sock startTLS:settings];
    }
#else
    {
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
        {
            [sock performBlock:^{
                if ([sock enableBackgroundingOnSocket])
                else
            }];
        }
#endif
    }
#endif
    
}

- (void)sendGameStartData {
    NSDictionary *startDic = @{@"cmd":@"start",
                               @"vmc_no":self.machineSn,
                               @"token":self.token,
                               @"type":[NSString stringWithFormat:@"%d", self.type]
    };
    [self sendMessageData:[startDic mj_JSONString]];
}

- (void)sendGameOverData {
    NSDictionary *startDic = @{@"cmd":@"push_coin_stop",
                               @"vmc_no":self.machineSn
    };
    [self sendMessageData:[startDic mj_JSONString]];
}

- (void)sendPushCoinDataWithNum:(NSString *)num {
    NSDictionary *dataDic = @{@"cmd":@"push_coin",
                              @"vmc_no":self.machineSn,
                              @"coin":num,
                              @"token":self.token
    };
    [self sendMessageData:[dataDic mj_JSONString]];
}

- (void)sendOpenWigerData {
    NSDictionary *dataDic = @{@"cmd":@"wiper_start",
                              @"vmc_no":self.machineSn
    };
    [self sendMessageData:[dataDic mj_JSONString]];
}

- (void)sendCloseWigerData {
    NSDictionary *dataDic = @{@"cmd":@"push_stop",
                               @"vmc_no":self.machineSn
    };
    [self sendMessageData:[dataDic mj_JSONString]];
}

- (void)sendAppointmentData {
    NSDictionary *dataDic = @{@"cmd":@"appointment",
                               @"vmc_no":self.machineSn
    };
    [self sendMessageData:[dataDic mj_JSONString]];
}

- (void)sendAppointmentCancleData {
    NSDictionary *dataDic = @{@"cmd":@"c_appointment",
                               @"vmc_no":self.machineSn
    };
    [self sendMessageData:[dataDic mj_JSONString]];
}

// 添加定时器
- (void)addTimer
{
    // 长连接定时器
   self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    // 把定时器添加到当前运行循环,并且调为通用模式
   [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
}

// 心跳连接
- (void)longConnectToSocket
{
   // 发送固定格式的数据,指令@"longConnect"
    NSDictionary *dataDic = @{@"vmc_no":self.machineSn, @"cmd":@"hb"};
    NSString *dataStr = [dataDic mj_JSONString];
    [self.dSocket writeData:[self convertSendData:dataStr] withTimeout:- 1 tag:0];
}

/**
 客户端socket断开

 @param sock 客户端socket
 @param err 错误描述
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
//    [self showMessageWithStr:@"断开连接"];
    NSLog(@"========>断开连接:%@", err);
    [self socketDisconnect];
}

- (void)socketDisconnect {
    self.dSocket.delegate = nil;
    self.dSocket = nil;
    [self.connectTimer invalidate];
    self.connectTimer = nil;
}

/**
 读取数据

 @param sock 客户端socket
 @param data 读取到的数据
 @param tag 本次读取的标记
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"back___data:");
    [self dealBackData:data];
    // 读取到服务端数据值后,能再次读取
    [self.dSocket readDataWithTimeout:- 1 tag:0];
   
}

#pragma mark - deal data
- (void)dealBackData:(NSData * )receiveData
{
    NSString *dataStr = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"[tcp] receive %ld -----> %@" , dataStr.length, dataStr);
    if (receiveData.length < 4) {
        return;
    }
    NSData *headData = [receiveData subdataWithRange:NSMakeRange(0, 4)];
    NSString *headStr = [[NSString alloc] initWithData:headData encoding:NSUTF8StringEncoding];
    if(![headStr isEqualToString:@"doll"])
    {
        return;
    }
    NSData *lengthData = [receiveData subdataWithRange:NSMakeRange(4, 4)];
    int tmpLength;
    [lengthData getBytes: &tmpLength length: sizeof(tmpLength)];
    int receiveLength = CFSwapInt32BigToHost(tmpLength);
    if(receiveData.length >= receiveLength)
    {
        NSData *temData = [receiveData subdataWithRange:NSMakeRange(8, receiveLength - 8)];
        NSString *dataLenght = [[NSString alloc] initWithData:temData encoding:NSUTF8StringEncoding];
        NSLog(@"[tcp] receive data --->%@",dataLenght);
        if(dataLenght == nil)
        return;
        YDSocketBackData *dataModel = [YDSocketBackData mj_objectWithKeyValues:temData];
        [self handleBackData:dataModel];
        NSData *lastData = [receiveData subdataWithRange:NSMakeRange(receiveLength, receiveData.length-receiveLength)];
        if (lastData.length > 0) {
            [self dealBackData:lastData];
        }
    }
}

- (void)handleBackData:(YDSocketBackData *)dataModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([dataModel.cmd isEqualToString:@"conn_r"]) {
            if(dataModel.status.integerValue == 200) {                
                if([self.delegate respondsToSelector:@selector(backConnectRoomData:)]) {
                    [self.delegate backConnectRoomData:dataModel];
                }
            }
        } else if ([dataModel.cmd isEqualToString:@"start_r"]) {//开始游戏
            if(dataModel.status.integerValue == 200) {
                if([self.delegate respondsToSelector:@selector(userStartPlay)]) {
                    [self.delegate userStartPlay];
                }
            }
        } else if ([dataModel.cmd isEqualToString:@"wiper_start_r"]) {
            if([self.delegate respondsToSelector:@selector(backOpenWiperStatus)]) {
                [self.delegate backOpenWiperStatus];
            }
        } else if ([dataModel.cmd isEqualToString:@"wiper_close_r"]) {
            if([self.delegate respondsToSelector:@selector(backCloseWiperStatus)]) {
                [self.delegate backCloseWiperStatus];
            }
        } else if ([dataModel.cmd isEqualToString:@"push_coin_result_r"]) {
            if([self.delegate respondsToSelector:@selector(backGetPushPoints:)]) {
                [self.delegate backGetPushPoints:dataModel.points];
            }
        } else if ([dataModel.cmd isEqualToString:@"appointment_r"]) {
            if(dataModel.status.integerValue == 0) {//可以直接上机
                if(dataModel.type.integerValue == 1) {//预约上机类型
                    [self sendGameStartData];
                } else {//取消预约类型
                    
                }
            } else if (dataModel.status.integerValue == 1) {//预约成功
                if([self.delegate respondsToSelector:@selector(backAppointmentSuccess)]) {
                    [self.delegate backAppointmentSuccess];
                }
            } else if (dataModel.status.integerValue == 2) {//预约失败
                
            } else if (dataModel.type.integerValue == 2) {//取消预约的返回
                if([self.delegate respondsToSelector:@selector(backAppointmentCancelResult)]) {
                    [self.delegate backAppointmentCancelResult];
                }
            }
        } else if ([dataModel.cmd isEqualToString:@"appointment_change"]) {//预约人数的变化
            NSInteger appointmentCount = dataModel.appointmentCount > 0 ? dataModel.appointmentCount : 0;
            if([self.delegate respondsToSelector:@selector(backAppointmentCount:)]) {
                [self.delegate backAppointmentCount:appointmentCount];
            }
        } else if ([dataModel.cmd isEqualToString:@"appointment_play"]) {//预约-轮到你玩游戏
            if([self.delegate respondsToSelector:@selector(backAppointmentEndToPlay)]) {
                [self.delegate backAppointmentEndToPlay];
            }
        } else if ([dataModel.cmd isEqualToString:@"grab_r"]) {
            if([self.delegate respondsToSelector:@selector(backUserExitRoom)]) {
                [self.delegate backUserExitRoom];
            }
        } else if ([dataModel.cmd isEqualToString:@"push_coin_r"]) {
            if([self.delegate respondsToSelector:@selector(backPushCoinStatus)]) {
                [self.delegate backPushCoinStatus];
            }
        }
        
        if(dataModel.status.integerValue == 40029) {
            [[YDAlertView sharedInstance] showTextMsg:dataModel.msg dispaly:2.0];
        }
    });
}

// 发送数据
- (void)sendMessageData:(NSString *)content
{   
    [self.dSocket writeData:[self convertSendData:content] withTimeout:- 1 tag:0];
}

- (NSData *)convertSendData:(NSString *)content
{
    NSData *data3 = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *data = [NSMutableData new];
    NSData *data1 = [@"doll" dataUsingEncoding:NSUTF8StringEncoding];
    int i = 4 + 4 + (int)data3.length;
    NSData *data2 = [NSData dataWithBytes: &i length: sizeof(i)];
    NSLog(@"send_data2_pre======>%@", data2);
    data2 = [self dataWithReverse:data2];
    NSLog(@"send_data2_end======>%@", data2);
    [data appendData:data1];
    [data appendData:data2];
    [data appendData:data3];
    return [data copy];
}

- (NSData *)dataWithReverse:(NSData *)srcData
{
    NSUInteger byteCount = srcData.length;
    NSMutableData *dstData = [[NSMutableData alloc] initWithData:srcData];
    NSUInteger halfLength = byteCount / 2;
    for (NSUInteger i=0; i<halfLength; i++) {
        NSRange begin = NSMakeRange(i, 1);
        NSRange end = NSMakeRange(byteCount - i - 1, 1);
        NSData *beginData = [srcData subdataWithRange:begin];
        NSData *endData = [srcData subdataWithRange:end];
        [dstData replaceBytesInRange:begin withBytes:endData.bytes];
        [dstData replaceBytesInRange:end withBytes:beginData.bytes];
    }
    return dstData;
}

@end
