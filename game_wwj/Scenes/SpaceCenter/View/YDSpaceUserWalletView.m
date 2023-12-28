//
//  YDSpaceUserWalletView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/30.
//

#import "YDSpaceUserWalletView.h"


@interface YDSpaceUserWalletView ()

@property (nonatomic,strong) UILabel *goldL;
@property (nonatomic,strong) UILabel *pointL;

@end

@implementation YDSpaceUserWalletView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.pointL = [self createSimpleViewWithType:0];
    self.goldL = [self createSimpleViewWithType:1];
}

- (UILabel *)createSimpleViewWithType:(NSInteger)type {
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    UIImageView *bgIv = [[UIImageView alloc] init];
    [contentView addSubview:bgIv];
    bgIv.backgroundColor = rgba(11, 0, 81, 1);
    bgIv.alpha = 0.3;
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    bgIv.layer.cornerRadius = 13;
    CGFloat width = 88;
    if(type == 0) {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).inset(12);
            make.top.bottom.mas_equalTo(self);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
    } else {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).inset(12+width);
            make.top.bottom.mas_equalTo(self);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(width);
            make.leading.mas_equalTo(self.mas_leading);
        }];
    }
    
    UIImage *image;
    if(type == 0) {
        image = [UIImage imageNamed:@"space_energy_icon"];
    } else {
        image = [UIImage imageNamed:@"space_coin_icon"];
    }
    
    UIImageView *imageIv = [[UIImageView alloc] initWithImage:image];
    [contentView addSubview:imageIv];
    [imageIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(contentView.mas_leading).offset(2);
        make.height.width.mas_equalTo(18);
    }];
    
    UILabel *contentL = [[UILabel alloc] init];
    contentL.font = [UIFont fontWithName:@"ZhenyanGB" size:13];
    contentL.text = @"00";
    contentL.textColor = UIColor.whiteColor;
    [contentView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(imageIv.mas_trailing).offset(2);
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(3);
    }];
    
//    UIImageView *addIv = [[UIImageView alloc] initWithImage:kImage(@"ico_bt_add")];
//    [contentView addSubview:addIv];
//    [addIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(contentView.mas_centerY);
//        make.trailing.mas_equalTo(contentView.mas_trailing).inset(3);
//    }];
    contentView.tag = type;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [contentView addGestureRecognizer:tap];
    return contentL;
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    NSString *title;
    if(tap.view.tag) {
        title = @"recharge";
    } else {
        title = @"change";
    }
    [self routerWithEventName:title userInfo:@{}];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self handleLargeValue:dataDic[@"goldCoin"] view:self.goldL];
    [self handleLargeValue:dataDic[@"points"] view:self.pointL];

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
