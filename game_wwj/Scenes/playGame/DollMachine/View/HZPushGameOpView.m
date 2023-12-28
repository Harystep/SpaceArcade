//
//  HZPushGameOpView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import "HZPushGameOpView.h"
#import <Masonry/Masonry.h>

@interface HZPushGameOpView ()

@property (nonatomic,strong) UILabel *coinL;

@property (nonatomic,strong) UIImageView *opBgIv;

@property (nonatomic,strong) UILabel *sortL;

@property (nonatomic,strong) UIView *gameOpView;

@property (nonatomic,assign) NSInteger mouse;

@property (nonatomic,strong) UILabel *mouseL;

@property (nonatomic,strong) NSTimer *dowmCountTimer;

@end

@implementation HZPushGameOpView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.coinL = [[UILabel alloc] init];
    [self addSubview:self.coinL];
    self.coinL.textColor = UIColor.whiteColor;
    self.coinL.text = @"10币/次";
    self.coinL.font = [UIFont systemFontOfSize:14];
    self.coinL.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.55];
    [self.coinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.height.mas_equalTo(46);
        make.width.mas_equalTo(72);
        make.bottom.mas_equalTo(self.mas_bottom).inset(40);
    }];
    self.coinL.textAlignment = NSTextAlignmentCenter;
    [self.coinL layoutIfNeeded];
    [self setupViewRound:self.coinL corners:UIRectCornerTopRight|UIRectCornerBottomRight];
    
    self.opBgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_start_icon"]];
    [self addSubview:self.opBgIv];
    [self.opBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.coinL.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.coinL.mas_centerY).offset(3);
        make.trailing.mas_equalTo(self.mas_trailing).inset(20);
    }];
    self.opBgIv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameOpClick)];
    [self.opBgIv addGestureRecognizer:tap];
    self.mouse = 100;
     
    self.sortL = [[UILabel alloc] init];
    [self addSubview:self.sortL];
    [self.sortL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.opBgIv.mas_centerX);
        make.bottom.mas_equalTo(self.opBgIv.mas_top).inset(10);
    }];
    self.sortL.textColor = UIColor.whiteColor;
    self.sortL.font = [UIFont systemFontOfSize:14];
}

- (void)gameOpClick {
    [self routerWithEventName:@"gameOp" userInfo:@{@"status":[NSString stringWithFormat:@"%tu", self.status]}];
}

- (void)setStartFlag:(BOOL)startFlag {
    if(startFlag) {
        self.opBgIv.hidden = YES;
        self.gameOpView.hidden = NO;
        if(!self.dowmCountTimer) {
            self.dowmCountTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(downCountOp) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.dowmCountTimer forMode:NSRunLoopCommonModes];
        }
    } else {
        self.opBgIv.hidden = NO;
        self.gameOpView.hidden = YES;
    }
}
- (void)setAppointCount:(NSInteger)appointCount {
    _appointCount = appointCount;
    if(appointCount == 0) {
        self.sortL.text = @"下一个到您";
    } else {
        self.sortL.text = [NSString stringWithFormat:@"当前排队：%tu", appointCount];
    }
}

- (void)setRefreshCount:(BOOL)refreshCount {
    if(refreshCount) {
        self.mouse = 100;
    }
}

- (void)stopDownCountTimer {
    [self.dowmCountTimer invalidate];
    self.dowmCountTimer = nil;
}

- (void)downCountOp {
    self.mouse --;
    if(self.mouse == 0) {
        [self.dowmCountTimer invalidate];
        self.dowmCountTimer = nil;
        [self routerWithEventName:@"gameOver" userInfo:@{}];
    } else {
        self.mouseL.text = [NSString stringWithFormat:@"%tu", self.mouse];
    }
}

- (void)pushGameType:(UIButton *)sender {
    [self routerWithEventName:@"coin" userInfo:@{@"num":[NSString stringWithFormat:@"%tu", sender.tag]}];
}

- (void)setupViewRound:(UIView *)targetView corners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds byRoundingCorners:corners
    cornerRadii:CGSizeMake(23, 23)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    // 设置大小
    maskLayer.frame = targetView.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    targetView.layer.mask = maskLayer;
    
}

- (void)setStatus:(NSInteger)status {
    _status = status;
    NSString *imageStr;
    switch (status) {
        case 0:
            self.sortL.hidden = YES;
            imageStr = @"push_start_icon";
            break;
        case 1:
            self.sortL.hidden = YES;
            imageStr = @"push_appoint_on_icon";
            break;
        case 2:
            self.sortL.hidden = NO;
            imageStr = @"push_appoint_cancle_icon";
            break;
            
        default:
            break;
    }
    self.opBgIv.image = [UIImage imageNamed:imageStr];
}

- (UIView *)gameOpView {
    if (!_gameOpView) {
        _gameOpView = [[UIView alloc] init];
        [self addSubview:_gameOpView];
        [_gameOpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.coinL.mas_centerY).offset(2);
            make.trailing.mas_equalTo(self.mas_trailing).inset(10);
            make.height.mas_equalTo(50);
            make.leading.mas_equalTo(self.coinL.mas_trailing);
        }];
        self.mouseL = [[UILabel alloc] init];
        [_gameOpView addSubview:self.mouseL];
        [self.mouseL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_gameOpView);
            make.trailing.mas_equalTo(_gameOpView.mas_trailing).inset(10);
            make.height.width.mas_equalTo(46);
        }];
        self.mouseL.textAlignment = NSTextAlignmentCenter;
        self.mouseL.font = [UIFont systemFontOfSize:15];
        self.mouseL.text = @"99";
        self.mouseL.backgroundColor = [UIColor colorWithRed:247/255.0 green:129/255.0 blue:11/255.0 alpha:1.0];
        self.mouseL.layer.cornerRadius = 23;
        self.mouseL.layer.masksToBounds = YES;
        self.mouseL.textColor = UIColor.whiteColor;
        
        UIButton *coin1 = [[UIButton alloc] init];
        [coin1 setBackgroundImage:[UIImage imageNamed:@"push_coin1_icon"] forState:UIControlStateNormal];
        [_gameOpView addSubview:coin1];
        coin1.tag = 1;
        [coin1 addTarget:self action:@selector(pushGameType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *coin3 = [[UIButton alloc] init];
        [coin3 setBackgroundImage:[UIImage imageNamed:@"push_coin3_icon"] forState:UIControlStateNormal];
        [_gameOpView addSubview:coin3];
        [coin1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(coin3.mas_width);
            make.centerY.mas_equalTo(_gameOpView);
            make.leading.mas_equalTo(self.coinL.mas_trailing).offset(10);
            make.trailing.mas_equalTo(coin3.mas_leading).inset(10);
        }];
        [coin3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(coin1.mas_trailing).offset(10);
            make.centerY.mas_equalTo(_gameOpView);
            make.trailing.mas_equalTo(self.mouseL.mas_leading).inset(10);
        }];
        coin3.tag = 3;
        [coin3 addTarget:self action:@selector(pushGameType:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _gameOpView;
}

@end
