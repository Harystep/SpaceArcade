//
//  YDSpaceSideLeftView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/30.
//

#import "YDSpaceSideLeftView.h"

@interface YDSpaceSideLeftView ()



@end

@implementation YDSpaceSideLeftView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    NSArray *titleArr = @[
        @{@"title":@"签到", @"image":@"space_sign_icon", @"color":rgba(223, 127, 228, 1)},
        @{@"title":@"勋章", @"image":@"space_reward_icon", @"color":rgba(186, 242, 242, 1)},
        @{@"title":@"任务", @"image":@"space_work_icon", @"color":UIColor.whiteColor},
        @{@"title":@"排行", @"image":@"space_sort_icon", @"color":rgba(193, 217, 255, 1)},
    ];
    CGFloat height = 50;
    for (int i = 0; i < titleArr.count; i ++) {
        UIView *itemView = [[UIView alloc] init];
        [self addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.mas_top).offset((height+15)*i);
        }];
        NSDictionary *dic = titleArr[i];
        [self createItemViewSubviewWithTitle:dic[@"title"] image:dic[@"image"] contentView:itemView titleColor:dic[@"color"]];
        itemView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [itemView addGestureRecognizer:tap];
    }
}

- (void)createItemViewSubviewWithTitle:(NSString *)title image:(NSString *)imageStr contentView:(UIView *)contentView titleColor:(UIColor *)color {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kImage(imageStr)];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(contentView);
        make.height.mas_equalTo(35);
    }];
    UILabel *titleL = [self createSimpleLabelWithTitle:title font:12 titleColor:color];
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconIv.mas_centerX);
        make.top.mas_equalTo(iconIv.mas_bottom);
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    NSString *title;
    switch (tap.view.tag) {
        case 0:
            title = @"sign";
            break;
        case 1:
            title = @"reward";
            break;
        case 2:
            title = @"work";
            break;
        case 3:
            title = @"sort";
            break;
            
        default:
            break;
    }
    [self routerWithEventName:title userInfo:@{}];
}

@end
