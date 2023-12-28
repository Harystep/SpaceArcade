//
//  YDPushAlertCoinNoneView.m
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import "YDPushAlertCoinNoneView.h"

@interface YDPushAlertCoinNoneView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UIImageView *statusIv;

@end

@implementation YDPushAlertCoinNoneView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIButton *maskBtn = [[UIButton alloc] init];
    [self addSubview:maskBtn];
    maskBtn.backgroundColor = UIColor.blackColor;
    maskBtn.alpha = 0.8;
    [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.maskBtn = maskBtn;
    [maskBtn addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(188);
        make.width.mas_equalTo(319);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_pay_fail"]];
    [self.contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(50);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    titleL.text = @"太空币不足，是否前往充值？";
    titleL.textColor = rgba(238, 170, 41, 1);
    titleL.font = [UIFont fontWithName:@"ZhenyanGB" size:18];
    self.contentL = titleL;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [self.contentView addSubview:cancelBtn];
    [cancelBtn setImage:[UIImage imageNamed:@"ico_exchange_cancel"] forState:UIControlStateNormal];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(self.contentView).inset(33);
    }];
    cancelBtn.tag = 0;
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [self.contentView addSubview:sureBtn];
    [sureBtn setImage:[UIImage imageNamed:@"ico_exchnage_sure"] forState:UIControlStateNormal];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(self.contentView).inset(33);
    }];
    sureBtn.tag = 1;
    [cancelBtn addTarget:self action:@selector(exchangeOperate:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn addTarget:self action:@selector(exchangeOperate:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)exchangeOperate:(UIButton *)sender {
    
    [self hideAlertView];
    if(sender.tag == 1) {
        if(self.sureRechargeBlock) {
            self.sureRechargeBlock();
        }
    }
}

- (void)showAlertView {
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.windows.firstObject addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideAlertView {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    [self removeFromSuperview];
}

@end
