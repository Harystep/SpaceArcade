//
//  YDSpaceMetalImage.m
//  game_wwj
//
//  Created by oneStep on 2023/12/4.
//

#import "YDSpaceMetalImage.h"
#import "UIView+Positon.h"

@interface YDSpaceMetalImage ()

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) UIButton *receiveBtn;

@property (nonatomic,strong) UILabel *coorL;

@property (nonatomic,assign) BOOL stopFlag;

@end

@implementation YDSpaceMetalImage

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.starIv = [[UIImageView alloc] init];
    [self addSubview:self.starIv];
    [self.starIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.starIv.userInteractionEnabled = YES;
    
    UIButton *btn = [[UIButton alloc] init];
    [self.starIv addSubview:btn];
    self.receiveBtn = btn;
    [btn addTarget:self action:@selector(receiveClick) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.starIv);
        make.centerY.mas_equalTo(self.starIv);
        make.height.width.mas_equalTo(50);
    }];
    btn.titleLabel.font = kBoldFont(14);
    btn.layer.cornerRadius = 25;
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    self.coorL = [[UILabel alloc] init];
    [self addSubview:self.coorL];
    self.coorL.font = kCustomFont(14);
    self.coorL.textColor = UIColor.whiteColor;
    [self.coorL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.starIv);
        make.bottom.mas_equalTo(self.mas_bottom).inset(20);
    }];
    [self.starIv layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimalMatel) name:@"kStopRewardStarKey" object:nil];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.receiveStatus = [dataDic[@"receiveStatus"] intValue];
    self.coorL.text = dataDic[@"name"];
}
//-1未完成 0 未领取 1已领取
- (void)setReceiveStatus:(int)receiveStatus {
    _receiveStatus = receiveStatus;
    if(receiveStatus == -1) {
        self.starIv.alpha = 0.5;
        self.receiveBtn.hidden = NO;
        self.receiveBtn.backgroundColor = UIColor.lightTextColor;
        [self.receiveBtn setTitle:@"未达标" forState:UIControlStateNormal];
    } else if (receiveStatus == 0){
        self.starIv.alpha = 1;
        self.receiveBtn.hidden = NO;
        self.receiveBtn.backgroundColor = rgba(188, 136, 35, 1);
        [self.receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
    } else {
        self.starIv.alpha = 1;
        self.receiveBtn.hidden = NO;
        self.receiveBtn.backgroundColor = rgba(242, 192, 96, 0.35);
        [self.receiveBtn setTitle:@"已领取" forState:UIControlStateNormal];
//        [self rotate360DegreeWithImageView:self.starIv];
        [self setStarAnimalMate];
    }
}

- (void)receiveClick {
    if(self.receiveStatus == 0) {
        [self routerWithEventName:@"receiveMetal" userInfo:@{@"id":self.dataDic[@"id"]}];
    }
}

- (void)stopAnimalMatel {
    self.stopFlag = YES;
}

- (void)setStarAnimalMate {
    [UIView animateWithDuration:2.0 animations:^{
        self.starIv.frame = CGRectMake(self.starIv.dn_x, self.starIv.dn_y-5, self.starIv.dn_width, self.starIv.dn_height);
    } completion:^(BOOL finished) {
        if (self.stopFlag == YES) return;
        [UIView animateWithDuration:2.0 animations:^{
            self.starIv.frame = CGRectMake(self.starIv.dn_x, self.starIv.dn_y+5, self.starIv.dn_width, self.starIv.dn_height);
        } completion:^(BOOL finished) {
            [self setStarAnimalMate];
        }];
    }];
}

- (void)rotate360DegreeWithImageView:(UIImageView *)imageView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//rotation.z
     //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
     animation.toValue =   [NSNumber numberWithFloat: M_PI*2];
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
     animation.duration = 4;
     animation.autoreverses = NO;
     animation.cumulative = NO;
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeForwards;
     animation.repeatCount = FLT_MAX; //如果这里想设置成一直自旋转，可以设置为FLT_MAX，
     [imageView.layer addAnimation:animation forKey:@"animation"];
     [imageView startAnimating];
}

@end
