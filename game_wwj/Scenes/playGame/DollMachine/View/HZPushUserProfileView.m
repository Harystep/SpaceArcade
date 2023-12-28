//
//  HZDollUserProfileView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/16.
//

#import "HZPushUserProfileView.h"
#import <SDWebImage/SDWebImage.h>

@interface HZPushUserProfileView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *statusL;

@property (nonatomic,strong) UIView *bgContentView;

@end

@implementation HZPushUserProfileView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_default_avatar"]];
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(self);
        make.width.height.mas_equalTo(32);
    }];
    self.iconIv.layer.cornerRadius = 16;
    self.iconIv.layer.masksToBounds = YES;
    
    self.bgContentView = [[UIView alloc] init];
    [self insertSubview:self.bgContentView belowSubview:self.iconIv];
    [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(-20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(26);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
    UIImageView *bgIv = [[UIImageView alloc] init];
    [self.bgContentView addSubview:bgIv];
    bgIv.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    bgIv.alpha = 0.55;
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgContentView);
    }];
    bgIv.layer.cornerRadius = 13;
        
    self.statusL = [[UILabel alloc] init];
    self.statusL.font = [UIFont systemFontOfSize:12];
    self.statusL.textColor = UIColor.whiteColor;
    self.statusL.text = @"空闲中";
    [self.bgContentView addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgContentView.mas_leading).offset(25);
        make.centerY.mas_equalTo(self.bgContentView.mas_centerY);
        make.trailing.mas_equalTo(self.bgContentView.mas_trailing).inset(3);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:nil];
}

- (void)setStatus:(NSInteger)status {
    _status = status;
    if(status == 1) {
        self.statusL.text = @"游戏中";
    } else {
        self.statusL.text = @"空闲中";
    }
}

@end
