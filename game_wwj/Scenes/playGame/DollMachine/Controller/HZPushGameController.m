//
//  HZDollGameController.m
//  game_wwj
//
//  Created by oneStep on 2023/11/16.
//

#import "HZPushGameController.h"
#import "HZPushUserProfileView.h"
#import "HZUserWalletView.h"
#import "HZPushOpView.h"
#import "HZPushScoreView.h"
#import "HZPushGameOpView.h"
#import "HZPushPullVideoView.h"
#import "YDSocketConnectService.h"
#import "ZCUserGameService.h"
#import "ZCSaveUserData.h"
#import "YDSocketBackData.h"
#import "YDPushRechargeAlertView.h"
#import "YDPushExchangeAlertView.h"
#import "YDPushRechargeModel.h"
#import "YDPushExchangeModel.h"
#import <MJExtension/MJExtension.h>
#import "YDExchangeAlertView.h"
#import "YDExchangeSucView.h"
#import "YDApplePayModule.h"
#import "YDRechaegeFailView.h"
#import "YDPushOffLineView.h"
#import <AVFoundation/AVFoundation.h>
#import "YDPushTimeOutView.h"
#import "YDPushAlertCoinNoneView.h"
#import "YDPushScreenPreView.h"

@interface HZPushGameController ()<YDSocketConnectServiceDelegate, YDPushScreenPreViewDelegate>

@property (nonatomic,strong) HZPushUserProfileView *userView;

@property (nonatomic,strong) HZUserWalletView *walletView;

@property (nonatomic,strong) HZPushOpView *opView;

@property (nonatomic,strong) HZPushScoreView *scoreView;

@property (nonatomic,strong) HZPushGameOpView *gameOpView;

@property (nonatomic,strong) HZPushPullVideoView *pullView;

@property (nonatomic,strong) YDSocketConnectService *dService;

@property (nonatomic,assign) BOOL openWiperFlag;

@property (nonatomic,strong) YDPushRechargeAlertView *rechargeView;
@property (nonatomic,strong) YDPushExchangeAlertView *exchangeView;
@property (nonatomic,strong) NSMutableArray *rechargeArr;
@property (nonatomic,strong) NSMutableArray *exchangeArr;
@property (nonatomic,strong) NSDictionary *userDic;
@property (nonatomic, strong) AVAudioPlayer     *audioPlay;

@property (nonatomic, strong) YDPushScreenPreView *preView;

@end

@implementation HZPushGameController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self configureSubviews];
       
    self.dService = [[YDSocketConnectService alloc] initWithMachineSn:self.machineSn port:self.port token:self.token address:self.addressUrl type:self.machineType];
    self.dService.delegate = self;
    
    [self getUserBaseInfo];
    
    self.applePayModule = [YDApplePayModule sharedInstance];
}

- (void)getRechargeListInfo {
    [ZCUserGameService getRechargeListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSMutableArray *dataArr = [NSMutableArray array];
        NSDictionary *monthDic = responseObj[@"data"][@"month"];
        NSDictionary *weekDic = responseObj[@"data"][@"week"];
        NSArray *normalArr = responseObj[@"data"][@"normal"];
        [dataArr addObject:[YDPushRechargeModel mj_objectWithKeyValues:weekDic]];
        [dataArr addObject:[YDPushRechargeModel mj_objectWithKeyValues:monthDic]];
        [dataArr addObjectsFromArray:[YDPushRechargeModel mj_objectArrayWithKeyValuesArray:normalArr]];
        self.rechargeArr = dataArr;
    }];
}

- (void)getExchangeListInfo {
    [ZCUserGameService getPointsExchangeListURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSMutableArray *dataArr = [NSMutableArray array];
        [dataArr addObjectsFromArray:[YDPushExchangeModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
        self.exchangeArr = dataArr;
    }];
}

- (void)getUserMachineInfo {
    [ZCUserGameService enterMachineRoomOperate:@{@"machineSn":self.machineSn} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"responseObj--->%@", responseObj);
        [self getUserBaseInfo];
    }];
}

- (void)getUserBaseInfo {
    [ZCUserGameService getUserInfoOperate:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"baseInfo--->%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        self.userDic = dataDic;
        self.userView.dataDic = dataDic;
        self.walletView.dataDic = dataDic;
        if(self.rechargeView) {
            self.rechargeView.dataDic = dataDic;
        }
        if(self.exchangeView) {
            self.exchangeView.dataDic = dataDic;
        }
    }];
}

- (void)configureSubviews {
    
    self.pullView = [[HZPushPullVideoView alloc] init];
    [self.view addSubview:self.pullView];
    [self.pullView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.pullView.machineSn = self.machineSn;
    
    UIButton *back = [[UIButton alloc] init];
    [self.view addSubview:back];
    [back setImage:[UIImage imageNamed:@"icon_game_exit"] forState:UIControlStateNormal];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(5);
        make.top.mas_equalTo(self.view.mas_top).offset(35);
        make.height.width.mas_equalTo(50);
    }];
    [back addTarget:self action:@selector(backOp) forControlEvents:UIControlEventTouchUpInside];
    
    self.userView = [[HZPushUserProfileView alloc] init];
    [self.view addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(back.mas_centerY);
        make.leading.mas_equalTo(back.mas_trailing);
    }];
    
    self.walletView = [[HZUserWalletView alloc] init];
    [self.view addSubview:self.walletView];
    [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(back.mas_centerY);
        make.trailing.mas_equalTo(self.view.mas_trailing);
    }];
    
    self.opView = [[HZPushOpView alloc] init];
    [self.view addSubview:self.opView];
    [self.opView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(12);
        make.top.mas_equalTo(back.mas_bottom).offset(32);
        make.width.mas_equalTo(40);
    }];
    
    self.scoreView = [[HZPushScoreView alloc] init];
    [self.view addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userView.mas_leading);
        make.top.mas_equalTo(self.userView.mas_bottom).offset(5);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(105);
    }];
    self.scoreView.hidden = YES;
    
    self.gameOpView = [[HZPushGameOpView alloc] init];
    [self.view addSubview:self.gameOpView];
    [self.gameOpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.preView];
    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)loadFinished {
    self.preView.hidden = YES;
    [self.preView removeFromSuperview];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    __weak typeof(self) weakself = self;
    
    if([eventName isEqualToString:@"off"]) {
        [self showOffGameAlertView];
    } else if ([eventName isEqualToString:@"ruler"]) {
        YDPushTimeOutView *rulerView = [[YDPushTimeOutView alloc] init];
        [rulerView showAlertView];
        rulerView.title = @"结算失败时";
        rulerView.content = @"在'我的' - '游戏记录' - '结算记录'中进行申诉 ";
        rulerView.sureOfflineBlock = ^{
        };
    } else if ([eventName isEqualToString:@"voice"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kChangeVoiceKey" object:nil];
        
    } else if ([eventName isEqualToString:@"repair"]) {
        
        YDPushOffLineView *offView = [[YDPushOffLineView alloc] init];
        [offView showAlertView];
        offView.title = @"该机器发生故障，确定上报？";
        offView.sureOfflineBlock = ^{
            
        };
    } else if ([eventName isEqualToString:@"recharge"]) {
        self.rechargeView = [[YDPushRechargeAlertView alloc] init];
//        self.rechargeView.dataArr = self.rechargeArr;
        self.rechargeView.dataDic = self.userDic;
        [self.rechargeView showRechargeView];
        self.rechargeView.selectRechargeItemBlock = ^(YDPushRechargeModel * _Nonnull model) {
            [weakself createAppleOrderOperate:model];
        };
    } else if ([eventName isEqualToString:@"change"]) {
        self.exchangeView = [[YDPushExchangeAlertView alloc] init];
//        self.exchangeView.dataArr = self.exchangeArr;
        self.exchangeView.dataDic = self.userDic;
        [self.exchangeView showAlertView];
        self.exchangeView.selectExchangeItemBlock = ^(YDPushExchangeModel * _Nonnull model) {
            [weakself showExchangeAlertView:model];
        };
    }  else if ([eventName isEqualToString:@"wiper"]) {
        if(self.openWiperFlag) {
            [self.dService sendCloseWigerData];
        } else {
            [self.dService sendOpenWigerData];
        }
    } else if ([eventName isEqualToString:@"gameOp"]) {
        NSInteger goldNum = [self.userDic[@"goldCoin"] integerValue];
        if(goldNum < self.minGold) {
            [self showCoinNoneView];
            return;
        }
        if([userInfo[@"status"] integerValue] == 2) { //取消预约
            [self.dService sendAppointmentCancleData];
        } else if ([userInfo[@"status"] integerValue] == 1) {//预约
            [self.dService sendAppointmentData];
        } else {//开始
            [self.dService sendGameStartData];
        }
    } else if ([eventName isEqualToString:@"coin"]) {
        NSInteger goldNum = [self.userDic[@"goldCoin"] integerValue];
        self.gameOpView.refreshCount = YES;
        NSString *num = userInfo[@"num"];
        if(goldNum > num.integerValue*10) {
            [self.dService sendPushCoinDataWithNum:num];
        } else {
            [self showCoinNoneView];
        }
    } else if ([eventName isEqualToString:@"gameOver"]) {
        [self.dService sendGameOverData];
        self.gameOpView.startFlag = NO;
        YDPushTimeOutView *alertView = [[YDPushTimeOutView alloc] init];
        [alertView showAlertView];
    }
}

- (void)showCoinNoneView {
    YDPushAlertCoinNoneView *alertView = [[YDPushAlertCoinNoneView alloc] init];
    [alertView showAlertView];
    __weak typeof(self) weakSelf = self;
    alertView.sureRechargeBlock = ^{
        weakSelf.rechargeView = [[YDPushRechargeAlertView alloc] init];
        weakSelf.rechargeView.dataArr = self.rechargeArr;
        weakSelf.rechargeView.dataDic = self.userDic;
        [weakSelf.rechargeView showRechargeView];
        weakSelf.rechargeView.selectRechargeItemBlock = ^(YDPushRechargeModel * _Nonnull model) {
            [weakSelf createAppleOrderOperate:model];
        };
    };
}

- (void)showExchangeAlertView:(YDPushExchangeModel *)model {
    YDExchangeAlertView *alertView = [[YDExchangeAlertView alloc] init];
    [alertView showAlertView];
    alertView.model = model;
    __weak typeof(self) weakself = self;
    alertView.sureExchangeBlock = ^{
        [weakself exchangePointsOp:model];
    };
}

- (void)exchangePointsOp:(YDPushExchangeModel *)model {
    [ZCUserGameService exchangePointsOperateURL:@{@"optionId":model.chargeId} completeHandler:^(id  _Nonnull responseObj) {
        if([responseObj isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                YDExchangeSucView *sucView = [[YDExchangeSucView alloc] init];
                NSInteger status = 0;
                if([responseObj[@"errCode"] integerValue] == 0) {
                    status = 1;
                    [self getUserBaseInfo];
                }
                [sucView showAlertView];
                sucView.status = status;
            });
        }
    }];
}

- (void)createAppleOrderOperate:(YDPushRechargeModel *)model {
    NSString *productId;
    if([model.title isEqualToString:@"周卡"] || [model.title isEqualToString:@"月卡"]) {
        productId = [NSString stringWithFormat:@"card:%@", model.chargeId];
    } else {
        productId = [NSString stringWithFormat:@"option:%@", model.chargeId];
    }
    [self showLoadingToView:self.rechargeView];
    [ZCUserGameService createChargeOrderOpURL:@{@"productId":productId} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSString *orderSn = responseObj[@"data"][@"orderSn"];
        [self.applePayModule pay:model.iosOption withOrderId:model.chargeId orderSn:orderSn withBlock:^(NSString * _Nullable receipt) {
            [self hideLoadingToView:self.rechargeView];
            [self getUserBaseInfo];
        } withFaileBlock:^(NSString * _Nonnull errMessage) {
            [self hideLoadingToView:self.rechargeView];
            [self showPayFailView];
        }];
    }];
}

- (void)playCoinVoice {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"voice_back.mp3" withExtension:Nil subdirectory:nil];
    self.audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    [self.audioPlay prepareToPlay];
    [self.audioPlay play];
}

- (void)showPayFailView {
    dispatch_async(dispatch_get_main_queue(), ^{
        YDRechaegeFailView *failView = [[YDRechaegeFailView alloc] init];
        [failView showAlertView];
    });
}

#pragma mark - YDSocketConnectServiceDelegate
- (void)backPushCoinStatus {
    [self getUserBaseInfo];
    [self playCoinVoice];
}
- (void)backConnectRoomData:(YDSocketBackData *)dataModel {
    if(dataModel.room_status.integerValue == 1) {//游戏中 需预约
        if(dataModel.isGame.integerValue == 1) {//自己在玩
            [self userStartPlay];
            self.userView.status = 1;
        } else {
            self.gameOpView.status = 1;
            self.userView.status = 0;
        }
    } else {
        self.gameOpView.status = 0;
        self.userView.status = 0;
    }
}
//开始游戏
- (void)userStartPlay {
    self.opView.startFlag = YES;
    self.gameOpView.startFlag = YES;
    self.scoreView.hidden = NO;
    self.userView.status = 1;
}

- (void)backOpenWiperStatus {
    self.openWiperFlag = YES;
}

- (void)backCloseWiperStatus {
    self.openWiperFlag = NO;
}
- (void)backGetPushPoints:(NSString *)points {
    self.scoreView.point = [points integerValue];
}

- (void)backAppointmentCount:(NSInteger)count {
    self.gameOpView.appointCount = count;
}

- (void)backAppointmentSuccess {
    self.gameOpView.status = 2;
}

- (void)backAppointmentEndToPlay {
    self.gameOpView.status = 0;
}
//exit room
- (void)backUserExitRoom {
//    self.gameOpView.status = 0;
//    [self dismissViewControllerAnimated:YES completion:nil];    
    self.gameOpView.status = 0;
    self.userView.status = 0;
}

- (void)showOffGameAlertView {
    __weak typeof(self) weakself = self;
    YDPushOffLineView *offView = [[YDPushOffLineView alloc] init];
    [offView showAlertView];
    offView.sureOfflineBlock = ^{
        [weakself.dService sendGameOverData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself dismissViewControllerAnimated:YES completion:nil];
        });
    };
}

- (void)backAppointmentCancelResult {
    self.gameOpView.status = 1;
}

- (void)backOp {
    if(self.opView.startFlag) {
        [self showOffGameAlertView];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc {
    [self.pullView stopStream];
    [self.dService socketDisconnect];
}

- (YDPushScreenPreView *)preView {
    if (_preView == nil) {
        _preView = [[YDPushScreenPreView alloc] init];
        _preView.delegate = self;
    }
    return _preView;
}

@end
