//
//  YDSpaceSimpleStarView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/30.
//

#import "YDSpaceSimpleStarView.h"
#import "UIView+Positon.h"

#define kAnimalTime 3.5

@interface YDSpaceSimpleStarView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UIImageView *bottomIv;

@property (nonatomic,assign) BOOL signAnimalFlag;

@end

@implementation YDSpaceSimpleStarView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.signAnimalFlag = YES;
    
    self.bottomIv = [[UIImageView alloc] initWithImage:kImage(@"space_gold_star_icon_bottom")];
    [self addSubview:self.bottomIv];
    [self.bottomIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kImage(@"space_gold_star_icon")];
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    UIImageView *alertIv = [[UIImageView alloc] initWithImage:kImage(@"space_star_alert_bg")];
    [self addSubview:alertIv];
    [alertIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(12);
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:@"探索星空-" font:15 titleColor:UIColor.whiteColor];
    [alertIv addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertIv.mas_top).offset(10);
        make.height.mas_equalTo(18);
        make.leading.mas_equalTo(alertIv.mas_leading).offset(10);
        make.trailing.mas_equalTo(alertIv.mas_trailing).inset(10);
    }];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.font = kCustomFont(16);
    
    [self.bottomIv layoutIfNeeded];
       
    [self makeBottomIvAnimal:self.bottomIv];

    [self makeStarIvAnimal:self.iconIv];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimalOp) name:@"kStartAnimalKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimalOp) name:@"kStopAnimalKey" object:nil];
}

- (void)startAnimalOp {
    self.signAnimalFlag = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self makeBottomIvAnimal:self.bottomIv];
        [self makeStarIvAnimal:self.iconIv];
    });
}

- (void)stopAnimalOp {
    self.signAnimalFlag = NO;
}

- (void)makeBottomIvAnimal:(UIImageView *)imageIv {
    [UIView animateWithDuration:kAnimalTime animations:^{
        imageIv.frame = CGRectMake(imageIv.dn_x+10, imageIv.dn_y+2, imageIv.dn_width, imageIv.dn_height);
    } completion:^(BOOL finished) {
        if (self.signAnimalFlag == NO)return;
        [self makeBackBottomAnimal:imageIv];
    }];
}

- (void)makeBackBottomAnimal:(UIImageView *)imageIv {
    [UIView animateWithDuration:kAnimalTime animations:^{
        imageIv.frame = CGRectMake(imageIv.dn_x-10, imageIv.dn_y-2, imageIv.dn_width, imageIv.dn_height);
    } completion:^(BOOL finished) {
        if (self.signAnimalFlag == NO)return;
        [self makeBottomIvAnimal:imageIv];
    }];
}

- (void)makeStarIvAnimal:(UIImageView *)imageIv {
    [UIView animateWithDuration:kAnimalTime animations:^{
        imageIv.frame = CGRectMake(imageIv.dn_x-10, imageIv.dn_y-2, imageIv.dn_width, imageIv.dn_height);
    } completion:^(BOOL finished) {
        if (self.signAnimalFlag == NO)return;
        [self makeBackStarAnimal:imageIv];
    }];
}

- (void)makeBackStarAnimal:(UIImageView *)imageIv {
    [UIView animateWithDuration:kAnimalTime animations:^{
        imageIv.frame = CGRectMake(imageIv.dn_x+10, imageIv.dn_y+2, imageIv.dn_width, imageIv.dn_height);
    } completion:^(BOOL finished) {
        if (self.signAnimalFlag == NO)return;
        [self makeStarIvAnimal:imageIv];
    }];
}

- (void)setStarName:(NSString *)starName {
    _starName = starName;
    self.iconIv.image = kImage(starName);
//    NSString *img = [NSString stringWithFormat:@"%@_bottom", starName];
    self.bottomIv.image = kImage(@"space_gold_star_icon_bottom");
        
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
