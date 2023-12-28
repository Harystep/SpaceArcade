//
//  HZUserWalletView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/16.
//

#import "HZUserWalletView.h"
#import <Masonry/Masonry.h>
#import "UIResponder+Router.h"

@interface HZUserWalletView ()

@property (nonatomic,strong) UILabel *goldL;
@property (nonatomic,strong) UILabel *pointL;

@end

@implementation HZUserWalletView

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
    bgIv.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    bgIv.alpha = 0.55;
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    bgIv.layer.cornerRadius = 13;
    contentView.tag = type;
    if(type == 0) {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).inset(12);
            make.top.bottom.mas_equalTo(self);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
        }];
    } else {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).inset(12+80+15);
            make.top.bottom.mas_equalTo(self);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(80);
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
        make.leading.mas_equalTo(contentView.mas_leading).offset(5);
        make.height.width.mas_equalTo(18);
    }];
    
    UILabel *contentL = [[UILabel alloc] init];
    contentL.font = [UIFont fontWithName:@"ZhenyanGB" size:13];
    contentL.text = @"00k";
    contentL.textColor = UIColor.whiteColor;
    [contentView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(imageIv.mas_trailing).offset(3);
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(3);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [contentView addGestureRecognizer:tap];
    return contentL;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self handleLargeValue:dataDic[@"goldCoin"] view:self.goldL];
    [self handleLargeValue:dataDic[@"points"] view:self.pointL];    

}

- (void)viewTapClick:(UITapGestureRecognizer *)tap {
    NSString *title;
    if(tap.view.tag == 1) {
        title = @"recharge";
    } else {
        title = @"change";
    }
    [self routerWithEventName:title userInfo:@{}];
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
//    }
    contentL.text = [NSString stringWithFormat:@"%@", value];
}

@end
