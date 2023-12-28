//
//  YDSpaceRewardController.m
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import "YDSpaceRewardController.h"
#import "YDPushRechargeAlertView.h"
#import "YDPushExchangeAlertView.h"
#import "ZCUserGameService.h"
#import "YDSpaceUserInfoView.h"
#import "YDSpaceUserWalletView.h"
#import "YDSpaceMetalImage.h"
#import "YDExchangeSucView.h"
#import "YDExchangeAlertView.h"
#import "YDRechaegeFailView.h"
#import "YDSpaceAnimalView.h"

@interface YDSpaceRewardController ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) NSDictionary *userDic;
@property (nonatomic,strong) YDPushRechargeAlertView *rechargeView;
@property (nonatomic,strong) YDPushExchangeAlertView *exchangeView;
@property (nonatomic,strong) YDSpaceUserInfoView *userView;
@property (nonatomic,strong) YDSpaceUserWalletView *walletView;

@property (nonatomic,strong) NSMutableArray *starArr;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) YDSpaceAnimalView *bgAnimalIv;

@end

@implementation YDSpaceRewardController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.bgAnimalIv startStartAnimal];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.bgAnimalIv stopStartAnimal];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kStopRewardStarKey" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = UIColor.whiteColor;
    [self configureBaseView];

    [self getUserBaseInfo];

    [self getSpaceMetalListInfo];
        
}

- (void)getSpaceMetalListInfo {
    [ZCUserGameService getSpaceMetalListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        self.dataArr = responseObj[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createStarSubviews];
        });
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

- (void)receiveSpaceMetalOp:(NSString *)content {
    [ZCUserGameService receiveSpaceMetalOpInfoURL:@{@"id":content} completeHandler:^(id  _Nonnull responseObj) {
        [self getSpaceMetalListInfo];
    }];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    __weak typeof(self) weakself = self;
    if([eventName isEqualToString:@"receiveMetal"]) {
        [self receiveSpaceMetalOp:userInfo[@"id"]];
    } else if ([eventName isEqualToString:@"recharge"]) {
        self.rechargeView = [[YDPushRechargeAlertView alloc] init];
        self.rechargeView.dataDic = self.userDic;
        [self.rechargeView showRechargeView];
        self.rechargeView.selectRechargeItemBlock = ^(YDPushRechargeModel * _Nonnull model) {
            [weakself createAppleOrderOperate:model];
        };
    } else if ([eventName isEqualToString:@"change"]) {
        self.exchangeView = [[YDPushExchangeAlertView alloc] init];
        self.exchangeView.dataDic = self.userDic;
        [self.exchangeView showAlertView];
        self.exchangeView.selectExchangeItemBlock = ^(YDPushExchangeModel * _Nonnull model) {
            [weakself showExchangeAlertView:model];
        };
    }
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
            [self showPayStatusView:YES];
            [self getUserBaseInfo];
        } withFaileBlock:^(NSString * _Nonnull errMessage) {
            [self hideLoadingToView:self.rechargeView];
            [self showPayStatusView:NO];
        }];
    }];
}

- (void)showPayStatusView:(BOOL)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        YDRechaegeFailView *failView = [[YDRechaegeFailView alloc] init];
        failView.status = status;
        [failView showAlertView];
    });
}

- (void)createStarSubviews {
    
    CGFloat heightTopMargin = STATUS_BAR_HEIGHT + 44 + 40;
    self.starArr = [NSMutableArray array];
    
    YDSpaceMetalImage *star1 = [[YDSpaceMetalImage alloc] init];
    [self.contentView addSubview:star1];
    star1.starIv.image = kImage(@"space_reward_star_1");
    [star1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(heightTopMargin);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(-20);
    }];
    [self.starArr addObject:star1];
    
    UIImageView *line1 = [[UIImageView alloc] initWithImage:kImage(@"space_reward_line1")];
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(star1.mas_bottom).inset(20);
        make.leading.mas_equalTo(star1.mas_leading).offset(163);
    }];
    
    YDSpaceMetalImage *star2 = [[YDSpaceMetalImage alloc] init];
    [self.contentView addSubview:star2];
    star2.starIv.image = kImage(@"space_reward_star_2");
    [star2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(star1.mas_bottom).offset(-97);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(-20);
    }];
    [self.starArr addObject:star2];
    
    UIImageView *line2 = [[UIImageView alloc] initWithImage:kImage(@"space_reward_line2")];
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(star2.mas_bottom).inset(35);
        make.trailing.mas_equalTo(star2.mas_trailing).inset(170);
    }];
    
    YDSpaceMetalImage *star3 = [[YDSpaceMetalImage alloc] init];
    [self.contentView addSubview:star3];
    star3.starIv.image = kImage(@"space_reward_star_3");
    [star3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(star1.mas_bottom).offset(37);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(-30);
    }];
    [self.starArr addObject:star3];
    
    UIImageView *line3 = [[UIImageView alloc] initWithImage:kImage(@"space_reward_line3")];
    [self.contentView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).inset(58);
        make.leading.mas_equalTo(line2.mas_leading).inset(35);
    }];
    
    YDSpaceMetalImage *star4 = [[YDSpaceMetalImage alloc] init];
    [self.contentView addSubview:star4];
    star4.starIv.image = kImage(@"space_reward_star_4");
    [star4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(star2.mas_bottom).offset(27);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(-26);
    }];
    [self.starArr addObject:star4];
    
    UIImageView *line4 = [[UIImageView alloc] initWithImage:kImage(@"space_reward_line4")];
    [self.contentView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line3.mas_bottom).inset(65);
        make.leading.mas_equalTo(line3.mas_leading).offset(-20);
    }];
    
    YDSpaceMetalImage *star5 = [[YDSpaceMetalImage alloc] init];
    [self.contentView addSubview:star5];
    star5.starIv.image = kImage(@"space_reward_star_5");
    [star5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(star3.mas_bottom).offset(22);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(-30);
    }];
    [self.starArr addObject:star5];
    
    UIImageView *line5 = [[UIImageView alloc] initWithImage:kImage(@"space_reward_line5")];
    [self.contentView addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line4.mas_bottom).inset(112);
        make.leading.mas_equalTo(line4.mas_leading).offset(-18);
    }];
    
    YDSpaceMetalImage *star6 = [[YDSpaceMetalImage alloc] init];
    [self.contentView addSubview:star6];
    star6.starIv.image = kImage(@"space_reward_star_6");
    [star6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(star4.mas_bottom).offset(46);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(-34);
    }];
    [self.starArr addObject:star6];
    
    UIImageView *line6 = [[UIImageView alloc] initWithImage:kImage(@"space_reward_line6")];
    [self.contentView addSubview:line6];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line5.mas_bottom).inset(30);
        make.leading.mas_equalTo(line5.mas_leading).offset(30);
    }];
    
    YDSpaceMetalImage *star7 = [[YDSpaceMetalImage alloc] init];
    [self.contentView addSubview:star7];
    star7.starIv.image = kImage(@"space_reward_star_7");
    [star7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(star5.mas_bottom).offset(120);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(-15);
    }];
    [self.starArr addObject:star7];
    
    UIImageView *line7 = [[UIImageView alloc] initWithImage:kImage(@"space_reward_line7")];
    [self.contentView addSubview:line7];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line6.mas_bottom).inset(44);
        make.leading.mas_equalTo(line6.mas_leading).offset(25);
    }];
    
    YDSpaceMetalImage *star8 = [[YDSpaceMetalImage alloc] init];
    [self.contentView addSubview:star8];
    star8.starIv.image = kImage(@"space_reward_star_8");
    [star8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(star6.mas_bottom).offset(127);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(-34);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(5);
    }];
    [self.starArr addObject:star8];
    
    for (NSInteger i = 0; i < self.starArr.count; i ++) {
        YDSpaceMetalImage *tarIv = self.starArr[i];
        NSString *iconStr = [NSString stringWithFormat:@"space_reward_medal_%tu", i+1];
        UIImageView *medalIv = [[UIImageView alloc] initWithImage:kImage(iconStr)];
        [tarIv addSubview:medalIv];
        NSString *starStr = [NSString stringWithFormat:@"space_reward_star_%tu", i+1];
        tarIv.starIv.image = kImage(starStr);
        NSDictionary *dataDic = self.dataArr[i];
        tarIv.dataDic = dataDic;
        CGFloat topMargin = 0;
        if(i%2==0) {
            topMargin = 25;
        } else if (i==1||i==3) {
           
            topMargin = 20;
        } else if (i==5) {
            topMargin = 12;
        } else {
            topMargin = 22;
        }
        [medalIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(tarIv.mas_centerX);
            make.top.mas_equalTo(tarIv.mas_top).offset(topMargin);
        }];
        if(i == self.dataArr.count-1) {
            [tarIv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(5);
            }];
        }
    }
}

- (void)configureBaseView {
    self.view.backgroundColor = UIColor.whiteColor;
    self.scView = [[UIScrollView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.scView.bounces = NO;
    self.scView.showsVerticalScrollIndicator = NO;
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView.mas_width);
    }];
    
    YDSpaceAnimalView *bgIv = [[YDSpaceAnimalView alloc] init];
    [self.contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    self.bgAnimalIv = bgIv;
    bgIv.iconIv.image = kImage(@"space_bg_icon");
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 30, 44)];
    [self.view addSubview:backBtn];
    [backBtn setImage:kImage(@"ico_white_back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleL = [[UILabel alloc] init];
    [self.view addSubview:titleL];
    titleL.textColor = UIColor.whiteColor;
    titleL.text = @"太空勋章";
    titleL.font = kBoldFont(17);
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(backBtn.mas_centerY);
    }];
    
    self.userView = [[YDSpaceUserInfoView alloc] init];
    [self.contentView addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).offset(STATUS_H+44);
        make.height.mas_equalTo(44);
    }];
    
    self.walletView = [[YDSpaceUserWalletView alloc] init];
    [self.contentView addSubview:self.walletView];
    [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.userView.mas_centerY);
        make.height.mas_equalTo(26);
    }];
    
}

- (void)backBtnClick {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
