//
//  YDSocketConnectService.h
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import <UIKit/UIKit.h>
#import "YDSocketBackData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YDSocketConnectServiceDelegate <NSObject>

- (void)backConnectRoomData:(YDSocketBackData *)model;

- (void)userStartPlay;//开始游戏

- (void)backPushCoinStatus;

- (void)backOpenWiperStatus;//开启雨刷

- (void)backCloseWiperStatus;//关闭雨刷

- (void)backGetPushPoints:(NSString *)points;//获得能量

- (void)backAppointmentSuccess;//预约成功

- (void)backAppointmentCount:(NSInteger)count;//返回预约人数

- (void)backAppointmentEndToPlay;//预约 轮到自己玩游戏

- (void)backUserExitRoom;

- (void)backAppointmentCancelResult;

@end

@interface YDSocketConnectService : NSObject

@property (nonatomic, weak) id<YDSocketConnectServiceDelegate> delegate;

- (void)socketConnect;

- (void)socketDisconnect;

- (void)sendGameStartData;

- (void)sendGameOverData;

- (void)sendPushCoinDataWithNum:(NSString *)num;

- (void)sendOpenWigerData;

- (void)sendCloseWigerData;

- (void)sendAppointmentData;

- (void)sendAppointmentCancleData;

- (instancetype)initWithMachineSn:(NSString *)machineSn port:(int)port token:(NSString *)token address:(NSString *)address type:(int)type;

@end

NS_ASSUME_NONNULL_END
