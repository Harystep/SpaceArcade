
//  YDSpaceCenterController.m
//  game_wwj
//
//  Created by oneStep on 2023/11/30.
//

#import "YDSpaceCenterController.h"
#import "YDSpaceSimpleStarView.h"
#import "YDSpaceCenterStarCell.h"
#import "YDSpaceSideLeftView.h"
#import "YDHelpTools.h"
#import "YDSpaceUserInfoView.h"
#import "YDSpaceUserWalletView.h"
#import "ZCUserGameService.h"
#import "game_wwj-Swift.h"
#import "YDPushRechargeAlertView.h"
#import "YDPushExchangeAlertView.h"
#import "YDPushRechargeModel.h"
#import "YDPushExchangeModel.h"
#import <MJExtension/MJExtension.h>
#import "YDRechaegeFailView.h"
#import "YDExchangeSucView.h"
#import "YDExchangeAlertView.h"
#import "YDSpaceWorkController.h"
#import "YDSpaceRewardController.h"
#import "ZCSaveUserData.h"
#import "HZPushGameController.h"
#import "YDSpaceRoomListModel.h"
#import "YDSpaceAnimalView.h"
#import "YDAlertView.h"
#import "YDPushOffLineView.h"
#import <MediaPlayer/MPVolumeView.h>
#import "YDAESDataTool.h"
#import <MJRefresh/MJRefresh.h>
#import "SYBBaseProcotolController.h"

@interface YDSpaceCenterController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) YDSpaceSimpleStarView *starView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) YDSpaceUserInfoView *userView;

@property (nonatomic,strong) YDSpaceUserWalletView *walletView;

@property (nonatomic,strong) NSDictionary *userDic;
@property (nonatomic,strong) YDPushRechargeAlertView *rechargeView;
@property (nonatomic,strong) YDPushExchangeAlertView *exchangeView;
@property (nonatomic,strong) NSMutableArray *rechargeArr;
@property (nonatomic,strong) NSMutableArray *exchangeArr;
@property (nonatomic,strong) NSArray *roomArr;
@property (nonatomic,strong) YDSpaceAnimalView *bgAnimalIv;
@property (nonatomic, strong) UISlider *volumeViewSlider;

@end

@implementation YDSpaceCenterController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kStartAnimalKey" object:nil];
    [self getUserBaseInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getRoomListInfo];
    [self.bgAnimalIv startStartAnimal];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kStopAnimalKey" object:nil];
    [self.bgAnimalIv stopStartAnimal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    YDSpaceAnimalView *bgIv = [[YDSpaceAnimalView alloc] init];
    [self.view addSubview:bgIv];
    bgIv.iconIv.image = kImage(@"space_bg_icon");
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.bgAnimalIv = bgIv;
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT+44+10);
        make.leading.trailing.mas_equalTo(self.view).inset(10);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(10);
    }];
    
    YDSpaceSideLeftView *leftView = [[YDSpaceSideLeftView alloc] init];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_top).offset(20);
        make.leading.mas_equalTo(self.view).offset(12);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(300);
    }];
    
    self.userView = [[YDSpaceUserInfoView alloc] init];
    [self.view addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(STATUS_H);
        make.height.mas_equalTo(44);
    }];
    
    self.walletView = [[YDSpaceUserWalletView alloc] init];
    [self.view addSubview:self.walletView];
    [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.userView.mas_centerY);
        make.height.mas_equalTo(26);
    }];
    
//    [self getRechargeListInfo];

//    [self getExchangeListInfo];
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kChangeNavKey" object:self.navigationController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiSendSignBackData) name:@"kSendSignOperateKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiDeleteAccountBackData) name:@"kDeleteAccountKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVoiceOp) name:@"kChangeVoiceKey" object:nil];
    if ([ZCSaveUserData getUserToken].length > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kSignKey" object:self.navigationController];;
        });
    }
    __weak typeof(self) weakself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getRoomListInfo];
    }];    
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
        
}

- (void)changeVoiceOp {
    float volume = [AVAudioSession sharedInstance].outputVolume;
    if (volume > 0.0) {
        [self.volumeViewSlider setValue:0.f animated:NO];
    } else {
        [self.volumeViewSlider setValue:0.35f animated:NO];
    }
    [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteAccountOp {
    [ZCUserGameService deleteAccountOpInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kJumpLogoUIKey" object:nil];
    }];
}

- (void)notiDeleteAccountBackData {
    __weak typeof(self) weakself = self;
    YDPushOffLineView *offView = [[YDPushOffLineView alloc] init];
    [offView showAlertView];
    offView.title = @"确定要注销账号吗？";
    offView.sureOfflineBlock = ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kJumpLogoUIKey" object:nil];
        [weakself deleteAccountOp];
    };
}

- (void)notiSendSignBackData {
    [ZCUserGameService sendUserSignOpInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        [self getUserBaseInfo];
    }];
}

- (void)getRoomListInfo {
    [ZCUserGameService getRoomListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"roomList:%@", responseObj);
        NSArray *dataArr = [YDSpaceRoomListModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        self.roomArr = dataArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        });
    }];
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

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([ZCSaveUserData judgeLoginStatus]) {        
        __weak typeof(self) weakself = self;
        if([eventName isEqualToString:@"sign"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kSignKey" object:self.navigationController];;
        } else if([eventName isEqualToString:@"reward"]) {
            YDSpaceRewardController *rewardVc = [[YDSpaceRewardController alloc] init];
            [self.navigationController pushViewController:rewardVc animated:YES];
        } else if([eventName isEqualToString:@"work"]) {
            YDSpaceWorkController *workVc = [[YDSpaceWorkController alloc] init];
            [self.navigationController pushViewController:workVc animated:YES];
        } else if([eventName isEqualToString:@"sort"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kRankListKey" object:self.navigationController];;
            });
            
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
        } else if ([eventName isEqualToString:@"jumpGame"]) {
            [self enterMachineRoomOp:userInfo];
        } else if ([eventName isEqualToString:@"jumpMine"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(ZCSaveUserData.getUserToken.length > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kJumpMineKey" object:userInfo];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSignKey" object:self.navigationController];;
                }
            });
        }
    }
}

- (void)enterMachineRoomOp:(NSDictionary *)userInfo {
    [ZCUserGameService enterMachineRoomOperate:@{@"machineSn":userInfo[@"machineSn"]} completeHandler:^(id  _Nonnull responseObj) {
        if ([responseObj[@"errCode"] integerValue] == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kJumpGameKey" object:userInfo];
            });
        } else {
            [[YDAlertView sharedInstance] showTextMsg:responseObj[@"errMsg"] dispaly:2.0];
        }
    }];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoadingToView:self.rechargeView];
    });
    [ZCUserGameService createChargeOrderOpURL:@{@"productId":productId} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        if ([responseObj isKindOfClass:[NSDictionary class]] && [responseObj[@"errCode"] integerValue] == 0) {
            NSString *orderSn = responseObj[@"data"][@"orderSn"];
            [self.applePayModule pay:model.iosOption withOrderId:model.chargeId orderSn:orderSn withBlock:^(NSString * _Nullable receipt) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoadingToView:self.rechargeView];
                    [self showPayStatusView:YES];
                    [self getUserBaseInfo];
                });
            } withFaileBlock:^(NSString * _Nonnull errMessage) {
                [self hideLoadingToView:self.rechargeView];
                [self showPayStatusView:NO];
            }];
        } else {
            [self hideLoadingToView:self.rechargeView];
        }
    }];
}

- (void)showPayStatusView:(BOOL)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        YDRechaegeFailView *failView = [[YDRechaegeFailView alloc] init];
        failView.status = status;
        [failView showAlertView];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.roomArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    YDSpaceCenterStarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDSpaceCenterStarCell" forIndexPath:indexPath];
    cell.model = self.roomArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(244, 320);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    YDSpaceRoomListModel *model = self.roomArr[indexPath.row];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSelectGameTypeKey" object:@{@"id":model.groupId}];
//    });
    
    SYBBaseProcotolController *procotol = [[SYBBaseProcotolController alloc] init];
    [self.navigationController pushViewController:procotol animated:YES];
}

#pragma mark - lazy UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayot];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        [_collectionView registerClass:[YDSpaceCenterStarCell class] forCellWithReuseIdentifier:@"YDSpaceCenterStarCell"];
    }
    return _collectionView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UISlider *)volumeViewSlider {
    if (_volumeViewSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in [volumeView subviews]) {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                _volumeViewSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeViewSlider;
}

@end
