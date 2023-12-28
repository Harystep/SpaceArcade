//
//  YDPushScreenPreView.m
//  game_wwj
//
//  Created by appleplay on 2023/12/11.
//

#import "YDPushScreenPreView.h"
#import "YDSpaceAnimalView.h"
#import "UIView+Positon.h"
#import "YDSimpleBaseView.h"

@interface YDPushScreenPreView ()

@property (nonatomic,strong) UIImageView *progressView;

@end

@implementation YDPushScreenPreView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIImageView *bgIv = [[UIImageView alloc] init];
    [self addSubview:bgIv];
    bgIv.image = kImage(@"space_bg_icon");
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *bgIcon = [[UIImageView alloc] initWithImage:kImage(@"push_screen_load_bg_icon")];
    [self addSubview:bgIcon];
    [bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).inset(200);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(280);
    }];
    
    self.progressView = [[UIImageView alloc] initWithImage:kImage(@"push_screen_load_icon")];
    [bgIcon addSubview:self.progressView];
    self.progressView.frame = CGRectMake(0, 0, 50, 26);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setPreViewLoading];
    });
    
    UILabel *titleL = [[UILabel alloc] init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(bgIcon.mas_bottom).offset(10);
    }];
    titleL.font = kFont(15);
    titleL.textColor = UIColor.whiteColor;
    titleL.text = @"加载中···";
}

- (void)setPreViewLoading {
    [UIView animateWithDuration:3.0 animations:^{
        self.progressView.frame = CGRectMake(self.progressView.dn_x, self.progressView.dn_y, 280, 26);
    } completion:^(BOOL finished) {
        [self.delegate loadFinished];
    }];
}

@end
