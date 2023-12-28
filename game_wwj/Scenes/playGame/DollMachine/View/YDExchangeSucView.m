//
//  YDExchangeSucView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import "YDExchangeSucView.h"


@interface YDExchangeSucView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UIImageView *statusIv;

@end

@implementation YDExchangeSucView

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
        make.height.mas_equalTo(224);
        make.width.mas_equalTo(319);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_exchange_bg"]];
    [self.contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    self.statusIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_exchange_right"]];
    [self.contentView addSubview:self.statusIv];
    [self.statusIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(100);
    }];    
    
    UILabel *titleL = [[UILabel alloc] init];
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusIv.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    titleL.text = @"兑换成功";
    titleL.textColor = rgba(238, 170, 41, 1);
    titleL.font = [UIFont fontWithName:@"ZhenyanGB" size:18];
    self.contentL = titleL;
}

- (void)exchangeOperate:(UIButton *)sender {
    
    [self hideAlertView];
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

- (void)setStatus:(NSInteger)status {
    if(status == NO) {
        self.statusIv.image = [UIImage imageNamed:@"ico_faile_x"];
        self.contentL.text = @"兑换失败";
    } else {
        self.statusIv.image = [UIImage imageNamed:@"ico_exchange_right"];
        self.contentL.text = @"兑换成功";
    }
}

@end
