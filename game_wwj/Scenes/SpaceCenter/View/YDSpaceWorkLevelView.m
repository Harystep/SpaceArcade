//
//  YDSpaceWorkLevelView.m
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import "YDSpaceWorkLevelView.h"

@interface YDSpaceWorkLevelView ()

@property (nonatomic,strong) UIImageView *levelIv;

@property (nonatomic,strong) UILabel *valueL;

@property (nonatomic,strong) UIButton *progressIv;

@property (nonatomic,strong) UIImageView *levelBgIv;

@end

@implementation YDSpaceWorkLevelView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kImage(@"space_work_level_bg")];
    [self addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.levelIv = [[UIImageView alloc] initWithImage:kImage(@"ico_level_0")];
    [bgIv addSubview:self.levelIv];
    [self.levelIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(bgIv.mas_trailing).inset(18);
        make.top.mas_equalTo(bgIv.mas_top).offset(6);
        make.width.height.mas_equalTo(34);
    }];
    self.levelIv.hidden = YES;
        
    UIImageView *levelBgIv = [[UIImageView alloc] initWithImage:kImage(@"space_work_level_speed_bg")];
    [bgIv addSubview:levelBgIv];
    [levelBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgIv.mas_top).offset(6);
        make.trailing.leading.mas_equalTo(bgIv).inset(23);
        make.height.mas_equalTo(34);
    }];
    self.levelBgIv = levelBgIv;
    [self.levelBgIv layoutIfNeeded];
    
    self.progressIv = [[UIButton alloc] init];
    [levelBgIv addSubview:self.progressIv];
    [self.progressIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(levelBgIv);
        make.leading.mas_equalTo(levelBgIv.mas_leading).offset(10);
        make.height.mas_equalTo(27);
        make.width.mas_equalTo(0.01);
    }];
    UIImage *image = [UIImage imageNamed:@"space_work_level_speed"];
    UIImage *enImage = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    [self.progressIv setBackgroundImage:enImage forState:UIControlStateNormal];
    
    self.valueL = [self createSimpleLabelWithTitle:@"00/00" font:14 titleColor:UIColor.whiteColor];
    [levelBgIv addSubview:self.valueL];
    [self.valueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(levelBgIv);
        make.centerY.mas_equalTo(levelBgIv);
    }];
    self.valueL.font = kCustomFont(14);
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *completeProgress = [self safeFloatNumWithContent:dataDic[@"completeProgress"]];
    NSString *totalProgress = [self safeFloatNumWithContent:dataDic[@"totalProgress"]];
    self.valueL.text = [NSString stringWithFormat:@"%@/%@", completeProgress, totalProgress];
    CGFloat ratio = [completeProgress doubleValue] / [totalProgress doubleValue];
    CGFloat viewWidth = (UIScreen.mainScreen.bounds.size.width - 46 - 15)*ratio;
    if(ratio > 0.0) {
        [self.progressIv mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(viewWidth);
        }];
    }
}

- (NSString *)safeFloatNumWithContent:(NSString *)content {
    NSString *safe = [NSString stringWithFormat:@"%@", content];
    if ([content isKindOfClass:[NSNull class]]) {
        safe = @"";
    } else if (content == nil) {
        safe = @"0";
    }
    return safe;
}

@end
