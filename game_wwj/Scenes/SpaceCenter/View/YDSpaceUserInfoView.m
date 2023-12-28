//
//  YDSpaceUserInfoView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/30.
//

#import "YDSpaceUserInfoView.h"

@interface YDSpaceUserInfoView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UIImageView *levelIv;

@property (nonatomic,strong) UILabel *expL;

@property (nonatomic,strong) UILabel *statusL;

@end

@implementation YDSpaceUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.iconIv = [[UIImageView alloc] initWithImage:kImage(@"ico_default_avatar")];
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(12);
        make.width.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self);
    }];
    self.iconIv.layer.cornerRadius = 20;
    self.iconIv.layer.masksToBounds = YES;
    self.iconIv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)];
    [self.iconIv addGestureRecognizer:tap];
    
    UIImageView *bgIcon = [[UIImageView alloc] initWithImage:kImage(@"space_level_bg_icon")];
    [self addSubview:bgIcon];
    [bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconIv.mas_centerY).offset(2);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(9);
    }];
    
    self.levelIv = [[UIImageView alloc] initWithImage:kImage(@"ico_level_0")];
    [self addSubview:self.levelIv];
    [self.levelIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(2);
    }];
    
    self.expL = [self createSimpleLabelWithTitle:@"0/100" font:13 titleColor:UIColor.whiteColor];
    [bgIcon addSubview:self.expL];
    [self.expL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgIcon.mas_centerY).offset(-2);
        make.leading.mas_equalTo(bgIcon.mas_leading).offset(33);
    }];
    self.expL.font = kCustomFont(13);
    
    self.statusL = [self createSimpleLabelWithTitle:@"未登录" font:12 titleColor:UIColor.whiteColor];
    [self addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconIv.mas_centerX);
        make.bottom.mas_equalTo(self.iconIv.mas_bottom);
    }];
    self.statusL.font = kFont(12);
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:kImage(@"ico_default_avatar")];
    NSDictionary *expDic = dataDic[@"memberLevelDto"];
    self.expL.text = [NSString stringWithFormat:@"%@/%@", expDic[@"progress"], expDic[@"targetMoney"]];
    NSInteger level = [expDic[@"level"] integerValue];
    NSString *levelStr = [NSString stringWithFormat:@"ico_level_%tu", level];
    self.levelIv.image = kImage(levelStr);
    self.statusL.hidden = YES;
}

- (void)iconClick {
    [self routerWithEventName:@"jumpMine" userInfo:@{}];
}

@end
