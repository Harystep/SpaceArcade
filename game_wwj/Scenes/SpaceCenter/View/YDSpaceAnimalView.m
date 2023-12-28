//
//  YDSpaceAnimalView.m
//  game_wwj
//
//  Created by oneStep on 2023/12/5.
//

#import "YDSpaceAnimalView.h"
#import "UIView+Positon.h"

#define kAnimalTime 15
#define kAnimalShortTime 20
#define kAnimalLongTime 40
#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height

@interface YDSpaceAnimalView ()

@property (nonatomic,strong) UIImageView *smallIv;

@property (nonatomic,strong) UIImageView *centerIv;

@property (nonatomic,strong) UIImageView *bottomIv;

@property (nonatomic,strong) UIImageView *midIv;

@property (nonatomic,strong) UIImageView *topStartIv;

@property (nonatomic,strong) UIImageView *bottomStartIv;

@property (nonatomic,assign) BOOL startAnimalFlag;//标记开始运动

@end

@implementation YDSpaceAnimalView

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
        make.edges.mas_equalTo(self);
    }];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    int topMargin = arc4random() % 200 + arc4random() % 100;
    self.smallIv = [[UIImageView alloc] initWithImage:kImage(@"space_coin_icon")];
    [self addSubview:self.smallIv];
    self.smallIv.alpha = 0.2;
    self.smallIv.frame = CGRectMake(100, topMargin, 25, 25);
    
    int topMarginCenter = arc4random() % 500 + arc4random() % 300;
    self.centerIv = [[UIImageView alloc] initWithImage:kImage(@"space_coin_icon")];
    [self addSubview:self.centerIv];
    self.centerIv.alpha = 0.2;
    self.centerIv.frame = CGRectMake(100, topMarginCenter, 40, 40);
    
    int topMarginBottom = 500 + arc4random() % 300;
    self.bottomIv = [[UIImageView alloc] initWithImage:kImage(@"space_coin_icon")];
    [self addSubview:self.bottomIv];
    self.bottomIv.alpha = 0.2;
    self.bottomIv.frame = CGRectMake(200, topMarginBottom, 40, 40);
        
    self.midIv = [[UIImageView alloc] initWithImage:kImage(@"space_coin_icon")];
    [self addSubview:self.midIv];
    self.midIv.alpha = 0.2;
    self.midIv.frame = CGRectMake(200, topMarginCenter, 40, 40);
    
    
    int topStartMargin = arc4random() % 500 + arc4random() % 200;
    self.topStartIv = [[UIImageView alloc] initWithImage:kImage(@"space_coin_icon")];
    [self addSubview:self.topStartIv];
    self.topStartIv.alpha = 0.2;
    self.topStartIv.frame = CGRectMake(100, topStartMargin, 40, 40);
        
    int bottomStartMargin = arc4random() % 500 + arc4random() % 200;
    self.bottomStartIv = [[UIImageView alloc] initWithImage:kImage(@"space_coin_icon")];
    [self addSubview:self.bottomStartIv];
    self.bottomStartIv.alpha = 0.2;
    self.bottomStartIv.frame = CGRectMake(300, bottomStartMargin, 40, 40);
    
    self.startAnimalFlag = NO;
}

- (void)startStartAnimal {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.startAnimalFlag = YES;
        [self timerOperate];
    });
}

- (void)stopStartAnimal {
    self.startAnimalFlag = NO;
}

- (void)timerOperate {
    [self setSmallIvAnimal];
    [self setCenterIvAnimal];
    [self setBottomIvAnimal];
    [self setMidIvAnimal];
    [self setTopStartIvAnimal];
    [self setBottomStartIvAnimal];
}

- (void)setMidIvAnimal {
    double ratio = (arc4random() % 130 + 20)/100.0;
    int x = -ratio * self.midIv.dn_width;
    int alpha = arc4random() % 30 + 15;
    int animal = arc4random() % 10 + kAnimalShortTime;
    [UIView animateWithDuration:animal animations:^{
        self.midIv.frame = CGRectMake(x, self.midIv.dn_y, self.midIv.dn_width*ratio, self.midIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        if (self.startAnimalFlag == NO) return;
        int topMargin = arc4random() % 500 + arc4random() % 300;
        self.midIv.frame = CGRectMake(kScreenWidth, topMargin, 50*1.4, 50*1.4);
        [self setMidIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.midIv.alpha = alpha / 100.0;
    }];
}

- (void)setBottomIvAnimal {
    double ratio = (arc4random() % 130 + 20)/100.0;
    int x = -ratio * self.bottomIv.dn_width;
    int alpha = arc4random() % 30 + 15;
    int animal = arc4random() % 10 + kAnimalShortTime;
    [UIView animateWithDuration:animal animations:^{
        self.bottomIv.frame = CGRectMake(x, self.bottomIv.dn_y, self.bottomIv.dn_width*ratio, self.bottomIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        if (self.startAnimalFlag == NO) return;
        int topMargin = 500 + arc4random() % 300;
        self.bottomIv.frame = CGRectMake(kScreenWidth, topMargin, 50*1.4, 50*1.4);
        [self setBottomIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.bottomIv.alpha = alpha / 100.0;
    }];
}

- (void)setCenterIvAnimal {
    
    double ratio = (arc4random() % 130 + 20)/100.0;
    int x = -ratio * self.centerIv.dn_width;
    int alpha = arc4random() % 30 + 15;
    int animal = arc4random() % 10 + kAnimalShortTime;
    [UIView animateWithDuration:animal animations:^{
        self.centerIv.frame = CGRectMake(x, self.centerIv.dn_y, self.centerIv.dn_width*ratio, self.centerIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        if (self.startAnimalFlag == NO) return;
        int topMargin = arc4random() % 500 + arc4random() % 300;
        self.centerIv.frame = CGRectMake(kScreenWidth, topMargin, 40*1.2, 40*1.2);
        [self setCenterIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.centerIv.alpha = alpha / 100.0;
    }];
}

- (void)setSmallIvAnimal{
    double ratio = (arc4random() % 130 + 20)/100.0;
    int alpha = arc4random() % 50 + 20;
    int x = -ratio * self.smallIv.dn_width;
    int animal = arc4random() % 10 + kAnimalShortTime;
    [UIView animateWithDuration:animal animations:^{
        self.smallIv.frame = CGRectMake(x, self.smallIv.dn_y, self.smallIv.dn_width*ratio, self.smallIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        if (self.startAnimalFlag == NO) return;
        int topMargin = arc4random() % 200 + arc4random() % 100;
        self.smallIv.frame = CGRectMake(kScreenWidth, topMargin, 25, 25);
        [self setSmallIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.smallIv.alpha = alpha / 100.0;
    }];
}

- (void)setBottomStartIvAnimal {
    
    double ratio = (arc4random() % 130 + 20)/100.0;
    int alpha = arc4random() % 50 + 15;
    int y = -ratio * self.bottomStartIv.dn_height;
    int animal = arc4random() % 10 + kAnimalLongTime;
    [UIView animateWithDuration:animal animations:^{
        self.bottomStartIv.frame = CGRectMake(self.bottomIv.dn_x, y, self.bottomStartIv.dn_width*ratio, self.bottomStartIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        if (self.startAnimalFlag == NO) return;
        int bottomMargin = arc4random() % 200 + 100;
        self.bottomStartIv.frame = CGRectMake(bottomMargin, kScreenHeight, 30, 30);
        [self setBottomStartIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.bottomStartIv.alpha = alpha / 100.0;
    }];
}

- (void)setTopStartIvAnimal{
    
    double ratio = (arc4random() % 130 + 20)/100.0;
    int alpha = arc4random() % 50 + 15;
    int y = -ratio * self.topStartIv.dn_height;
    int animal = arc4random() % 10 + kAnimalLongTime;
    [UIView animateWithDuration:animal animations:^{
        self.topStartIv.frame = CGRectMake(self.topStartIv.dn_x, kScreenHeight, self.topStartIv.dn_width*ratio, self.topStartIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        if (self.startAnimalFlag == NO) return;
        int startMargin = arc4random() % 200 + arc4random() % 100;
        self.topStartIv.frame = CGRectMake(startMargin, y, 30, 30);
        [self setTopStartIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.topStartIv.alpha = alpha / 100.0;
    }];
}

@end
