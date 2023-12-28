//
//  HZPushScoreView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/16.
//

#import "HZPushScoreView.h"
#import <Masonry/Masonry.h>

@interface HZPushScoreView ()

@property (nonatomic,strong) UILabel *scoreL;

@end

@implementation HZPushScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.55];
    bgView.layer.cornerRadius = 13;
    bgView.layer.masksToBounds = YES;
    
    UIButton *down = [[UIButton alloc] init];
    [bgView addSubview:down];
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView);
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(6);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    [down setTitle:@"下机" forState:UIControlStateNormal];
    down.backgroundColor = [UIColor colorWithRed:98/255.0 green:78/255.0 blue:222/255.0 alpha:1.0];
    down.layer.cornerRadius = 10;
    [down addTarget:self action:@selector(downOp) forControlEvents:UIControlEventTouchUpInside];
    [down setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    down.titleLabel.font = [UIFont systemFontOfSize:12];
    
    self.scoreL = [[UILabel alloc] init];
    self.scoreL.textColor = [UIColor colorWithRed:247/255.0 green:129/255.0 blue:11/255.0 alpha:1.0];
    self.scoreL.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:self.scoreL];
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView);
        make.leading.mas_equalTo(bgView.mas_leading).offset(6);
        make.trailing.mas_equalTo(down.mas_leading).inset(6);
    }];
    self.scoreL.text = @"赢 0 分";
    self.scoreL.adjustsFontSizeToFitWidth = YES;
}

- (void)downOp {
    [self routerWithEventName:@"off" userInfo:@{}];
}

- (void)setPoint:(NSInteger)point {
    self.scoreL.text = [NSString stringWithFormat:@"赢 %tu 分", point];
}

@end
