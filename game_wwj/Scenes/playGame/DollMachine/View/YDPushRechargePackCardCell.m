//
//  YDPushRechargePackCardCell.m
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import "YDPushRechargePackCardCell.h"
#import <Masonry/Masonry.h>

#define rgba(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface YDPushRechargePackCardCell ()

@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UILabel *coinL;//li de
@property (nonatomic,strong) UILabel *giveL;//meiri
@property (nonatomic,strong) UILabel *extraL;//ewai
@property (nonatomic,strong) UILabel *moneyL;

@end

@implementation YDPushRechargePackCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIImageView *imageIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_charge_week_bg_icon"]];
    [self.contentView addSubview:imageIv];
    [imageIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    self.bgIcon = imageIv;
    imageIv.layer.cornerRadius = 10;
    imageIv.layer.masksToBounds = YES;
    
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(18);
        make.width.height.mas_equalTo(48);
    }];
    
    self.coinL = [[UILabel alloc] init];
    [self.contentView addSubview:self.coinL];
    [self.coinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.height.mas_equalTo(20);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(10);
    }];
    self.coinL.font = [UIFont boldSystemFontOfSize:17];
    
    self.giveL = [[UILabel alloc] init];
    [self.contentView addSubview:self.giveL];
    [self.giveL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coinL.mas_bottom).offset(8);
        make.height.mas_equalTo(20);
        make.leading.mas_equalTo(self.coinL.mas_leading);
    }];
    self.giveL.font = [UIFont boldSystemFontOfSize:15];
    
    self.extraL = [[UILabel alloc] init];
    [self.contentView addSubview:self.extraL];
    [self.extraL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giveL.mas_bottom).offset(5);
        make.leading.mas_equalTo(self.coinL.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(105);
    }];
    self.extraL.numberOfLines = 0;
    self.extraL.font = [UIFont boldSystemFontOfSize:15];
    
    self.moneyL = [[UILabel alloc] init];
    [self.contentView addSubview:self.moneyL];
    [self.moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(18);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(82);
    }];
    self.moneyL.font = [UIFont boldSystemFontOfSize:15];
    self.moneyL.layer.cornerRadius = 17;
    self.moneyL.layer.masksToBounds = YES;
    self.moneyL.textAlignment = NSTextAlignmentCenter;
    self.moneyL.backgroundColor = rgba(254, 238, 208, 1);
}

- (void)setType:(NSInteger)type {
    type = _type;
        
}

- (void)setModel:(YDPushRechargeModel *)model {
    _model = model;
    UIColor *color;
    if([model.title isEqualToString:@"周卡"]) {
        self.iconIv.image = [UIImage imageNamed:@"push_charge_week_icon"];
        color = rgba(104, 71, 9, 1);
    } else {
        self.iconIv.image = [UIImage imageNamed:@"push_charge_month_icon"];
        color = rgba(20, 53, 118, 1);
    }
    self.moneyL.textColor = color;
    self.coinL.textColor = color;
    self.extraL.textColor = color;
    self.giveL.textColor = color;
    self.coinL.text = [NSString stringWithFormat:@"购买立得%@太空币", model.money];
    self.giveL.text = [NSString stringWithFormat:@"每日赠送%@钻石", model.dayMoney];
    self.extraL.text = model.desc;
    self.moneyL.text = [NSString stringWithFormat:@"￥%@", model.price];
}

@end
