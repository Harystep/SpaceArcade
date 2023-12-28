//
//  YDPushRechargeItemCardCell.m
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import "YDPushRechargeItemCardCell.h"
#import <Masonry/Masonry.h>

@interface YDPushRechargeItemCardCell ()

@property (nonatomic,strong) UILabel *coinL;

@property (nonatomic,strong) UILabel *giveL;

@property (nonatomic,strong) UILabel *moneyL;

@end

@implementation YDPushRechargeItemCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIImageView *imageIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_charge_item_bg"]];
    [self.contentView addSubview:imageIv];
    [imageIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    imageIv.layer.cornerRadius = 10;
    imageIv.layer.masksToBounds = YES;
    
    self.coinL = [[UILabel alloc] init];
    [self.contentView addSubview:self.coinL];
    [self.coinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(self.contentView.mas_centerX).offset(12);
    }];
    self.coinL.textColor = UIColor.whiteColor;
    self.coinL.font = [UIFont boldSystemFontOfSize:17];
    
    UIImageView *coinIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space_coin_icon"]];
    [self.contentView addSubview:coinIv];
    [coinIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.coinL.mas_centerY);
        make.trailing.mas_equalTo(self.coinL.mas_leading);
        make.height.width.mas_equalTo(25);
    }];
    
    self.moneyL = [[UILabel alloc] init];
    self.moneyL.textColor = UIColor.whiteColor;
    self.moneyL.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:self.moneyL];
    [self.moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(12);
    }];
    
    UIImageView *lineIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_line_icon"]];
    [self.contentView addSubview:lineIv];
    [lineIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coinL.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_recharge_ju_icon"]];
    [self.contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(30);
    }];
    UIImageView *diamondIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_diamond_icon"]];
    [bgIv addSubview:diamondIv];
    [diamondIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgIv.mas_centerY);
        make.trailing.mas_equalTo(bgIv.mas_trailing).inset(2);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(19);
    }];
        
    self.giveL = [[UILabel alloc] init];
    self.giveL.textColor = UIColor.whiteColor;
    self.giveL.font = [UIFont boldSystemFontOfSize:14];
    [bgIv addSubview:self.giveL];
    [self.giveL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgIv.mas_centerY);
        make.trailing.mas_equalTo(diamondIv.mas_leading);
        make.leading.mas_equalTo(bgIv.mas_leading);
    }];
    
}

- (void)setModel:(YDPushRechargeModel *)model {
    _model = model;
    self.coinL.text = model.money;
    self.moneyL.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.giveL.text = model.desc;
}

@end
