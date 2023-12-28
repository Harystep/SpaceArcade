//
//  YDPushWalletView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import "YDPushWalletView.h"
#import <Masonry/Masonry.h>

@interface YDPushWalletView ()

@property (nonatomic,strong) UILabel *goldL;
@property (nonatomic,strong) UILabel *pointL;
@property (nonatomic,strong) UILabel *diamondL;

@end

@implementation YDPushWalletView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.pointL = [self createSimpleViewWithType:0];
    self.goldL = [self createSimpleViewWithType:1];
    self.diamondL = [self createSimpleViewWithType:2];
}

- (UILabel *)createSimpleViewWithType:(NSInteger)type {
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    UIImageView *bgIv = [[UIImageView alloc] init];
    [contentView addSubview:bgIv];
    bgIv.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    bgIv.alpha = 0.25;
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    bgIv.layer.cornerRadius = 13;
    
    if(type == 0) {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).inset(12);
            make.top.bottom.mas_equalTo(self);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
    } else if(type == 1) {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).inset(12+80+15);
            make.top.bottom.mas_equalTo(self);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
    } else {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).inset(12+(80+15)*2);
            make.top.bottom.mas_equalTo(self);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
            make.leading.mas_equalTo(self.mas_leading);
        }];
    }
    
    UIImage *image;
    if(type == 0) {
        image = [UIImage imageNamed:@"space_energy_icon"];
    } else if(type == 1) {
        image = [UIImage imageNamed:@"space_coin_icon"];
    } else {
        image = [UIImage imageNamed:@"push_diamond_icon"];
    }
    
    UIImageView *imageIv = [[UIImageView alloc] initWithImage:image];
    [contentView addSubview:imageIv];
    [imageIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(contentView.mas_leading).offset(5);
        make.height.width.mas_equalTo(18);
    }];
    
    UILabel *contentL = [[UILabel alloc] init];
    contentL.font = [UIFont fontWithName:@"ZhenyanGB" size:12];
    contentL.text = @" ";
    contentL.textColor = UIColor.whiteColor;
    [contentView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(imageIv.mas_trailing).offset(3);
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(3);
    }];
    return contentL;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self handleLargeValue:dataDic[@"goldCoin"] view:self.goldL];
    [self handleLargeValue:dataDic[@"points"] view:self.pointL];
    [self handleLargeValue:dataDic[@"money"] view:self.diamondL];
}

- (void)handleLargeValue:(NSString *)value view:(UILabel *)contentL {
//    if([value integerValue] > 1000) {
//        NSInteger num = [value integerValue];
//        if(num < 10000) {
//            contentL.text = [NSString stringWithFormat:@"%.2fK", (num*1.0)/1000];
//        } else {
//            contentL.text = [NSString stringWithFormat:@"%tuK", num/1000];
//        }
//    } else {
//        contentL.text = [NSString stringWithFormat:@"%@", value];
//    }
    contentL.text = [NSString stringWithFormat:@"%@", value];
}

@end
