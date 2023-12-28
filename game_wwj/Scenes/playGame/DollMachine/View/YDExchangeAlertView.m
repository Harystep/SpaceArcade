//
//  YDExchangeAlertView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import "YDExchangeAlertView.h"

@interface YDExchangeAlertView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UILabel *contentL;

@end

@implementation YDExchangeAlertView

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
    //  ico_exchange_sure
    
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
    
    UILabel *titleL = [[UILabel alloc] init];
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(95);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    titleL.textColor = UIColor.whiteColor;    
    titleL.font = [UIFont fontWithName:@"ZhenyanGB" size:18];
    self.contentL = titleL;
}

- (void)exchangeOperate:(UIButton *)sender {
    
    [self hideAlertView];
    if(sender.tag == 1) {
        if(self.sureExchangeBlock) {
            self.sureExchangeBlock();
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

- (void)setModel:(YDPushExchangeModel *)model {
    _model = model;
    NSString *content = [NSString stringWithFormat:@"确认%@能量转换%@太空币", model.points, model.goldCoin];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:rgba(238, 170, 41, 1)} range:NSMakeRange(2, model.points.length)];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:rgba(238, 170, 41, 1)} range:NSMakeRange(content.length-3-model.goldCoin.length, model.goldCoin.length)];
    self.contentL.attributedText = attrStr;
}

@end
