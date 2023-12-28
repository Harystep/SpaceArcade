//
//  HZDollOpView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/16.
//

#import "HZPushOpView.h"
#import "HZSimpleBtnView.h"

@interface HZPushOpView ()

@property (nonatomic,strong) NSArray *titleArr;

@property (nonatomic,strong) HZSimpleBtnView *wiperView;

@end

@implementation HZPushOpView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.titleArr = @[@{@"image":@"push_ruler_icon", @"title":@"规则"},
                      @{@"image":@"push_voice_icon", @"title":@"声音"},
                      @{@"image":@"push_repair_icon", @"title":@"保修"},
                      @{@"image":@"push_recharge_icon", @"title":@"充值"},
                      @{@"image":@"push_change_icon", @"title":@"兑换"},
                      @{@"image":@"push_wiper_icon", @"title":@"雨刮"},
    ];
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.55];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    contentView.layer.cornerRadius = 20;
    CGFloat height = 40;
    for (int i = 0; i < self.titleArr.count; i ++) {
        NSDictionary *dic = self.titleArr[i];
        HZSimpleBtnView *item = [[HZSimpleBtnView alloc] init];
        [contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView.mas_top).offset(20+(10+height)*i);
            make.leading.trailing.mas_equalTo(contentView);
        }];
        item.iconIv.image = [UIImage imageNamed:dic[@"image"]];
        item.titleL.text = dic[@"title"];
        if(i == self.titleArr.count-1) {
            [item mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.01);
                make.bottom.mas_equalTo(contentView.mas_bottom).inset(10);
            }];
            self.wiperView = item;
            self.wiperView.hidden = YES;
        } else {
            [item mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewClick:)];
        item.tag = i;
        [item addGestureRecognizer:tap];
    }
}

- (void)itemViewClick:(UITapGestureRecognizer *)tap {
    NSString *title;
    switch (tap.view.tag) {
        case 0:
            title = @"ruler";
            break;
            
        case 1:
            title = @"voice";
            break;
            
        case 2:
            title = @"repair";
            break;
            
        case 3:
            title = @"recharge";
            break;
            
        case 4:
            title = @"change";
            break;
            
        case 5:
            title = @"wiper";
            break;
            
        default:
            break;
    }
    [self routerWithEventName:title userInfo:@{}];
}

- (void)setStartFlag:(BOOL)startFlag {
    _startFlag = startFlag;
    if(startFlag) {
        [self.wiperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
        self.wiperView.hidden = NO;
    } else {
        [self.wiperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.01);
        }];
        self.wiperView.hidden = YES;
    }
}

@end
