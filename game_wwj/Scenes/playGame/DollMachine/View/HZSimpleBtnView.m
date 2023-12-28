//
//  HZSimpleBtnView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/16.
//

#import "HZSimpleBtnView.h"

@interface HZSimpleBtnView ()

@end

@implementation HZSimpleBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {

    self.iconIv = [[UIImageView alloc] init];
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.width.height.mas_equalTo(35);
        make.centerX.mas_equalTo(self);
    }];
    
    self.titleL = [[UILabel alloc] init];
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(-10);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(30);
    }];
    self.titleL.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.55];
    self.titleL.font = [UIFont systemFontOfSize:10];
    self.titleL.layer.cornerRadius = 7.5;
    self.titleL.layer.masksToBounds = YES;
    self.titleL.textColor = UIColor.whiteColor;
    self.titleL.textAlignment = NSTextAlignmentCenter;
    
}

@end
