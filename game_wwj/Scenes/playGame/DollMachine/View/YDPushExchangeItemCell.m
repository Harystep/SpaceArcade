//
//  YDPushExchangeItemCell.m
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import "YDPushExchangeItemCell.h"
#import <Masonry/Masonry.h>

@interface YDPushExchangeItemCell ()

@property (nonatomic,strong) UILabel *coinL;

@property (nonatomic,strong) UILabel *pointL;

@end

@implementation YDPushExchangeItemCell

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
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space_coin_icon"]];
    [self.contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
    }];
    
    self.coinL = [[UILabel alloc] init];
    self.coinL.textColor = UIColor.whiteColor;
    self.coinL.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.coinL];
    [self.coinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(iconIv.mas_bottom).offset(5);
    }];
    
    self.pointL = [[UILabel alloc] init];
    self.pointL.textColor = UIColor.whiteColor;
    self.pointL.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.pointL];
    [self.pointL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(10);
    }];
    
}

- (void)setModel:(YDPushExchangeModel *)model {
    _model = model;
    self.coinL.text = [NSString stringWithFormat:@"%@%@", model.goldCoin, @"太空币"];
    self.pointL.text = [NSString stringWithFormat:@"%@%@", model.points, @"能量"];
}

@end
