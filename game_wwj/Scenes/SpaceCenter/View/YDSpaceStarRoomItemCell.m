//
//  YDSpaceStarRoomItemCell.m
//  game_wwj
//
//  Created by oneStep on 2023/11/30.
//

#import "YDSpaceStarRoomItemCell.h"
#import "YDSimpleBaseView.h"

@interface YDSpaceStarRoomItemCell ()

@property (nonatomic,strong) UIImageView *roomIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *statusL;

@property (nonatomic,strong) UIImageView *bgIv;

@property (nonatomic,strong) UILabel *alertL;

@end

@implementation YDSpaceStarRoomItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.roomIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.roomIv];
    [self.roomIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    self.roomIv.layer.cornerRadius = 5;
    self.roomIv.layer.masksToBounds = YES;
    
    self.bgIv = [[UIImageView alloc] init];
    [self.roomIv addSubview:self.bgIv];
    [self.bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.roomIv);
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:@" " font:9 titleColor:UIColor.whiteColor];
    [self.contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.roomIv.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
        make.leading.trailing.mas_equalTo(self.contentView).inset(1);
    }];
    self.nameL.textAlignment = NSTextAlignmentCenter;
    self.nameL.backgroundColor = rgba(0, 0, 0, 0.30);
    self.nameL.layer.cornerRadius = 7;
    self.nameL.layer.masksToBounds = YES;
    
    self.statusL = [self createSimpleLabelWithTitle:@"" font:10 titleColor:UIColor.whiteColor];
    [self.bgIv addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgIv);
        make.centerY.mas_equalTo(self.bgIv);
    }];
    self.statusL.hidden = YES;
    self.bgIv.hidden = YES;
    
    self.alertL = [self createSimpleLabelWithTitle:@"" font:10 titleColor:UIColor.whiteColor];
    [self.roomIv addSubview:self.alertL];
    [self.alertL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.mas_equalTo(self.roomIv);
        make.height.mas_equalTo(15);
    }];
    self.alertL.textAlignment = NSTextAlignmentCenter;
    self.alertL.backgroundColor = rgba(0, 0, 0, 0.30);
//    self.alertL.layer.cornerRadius = 5;
//    self.alertL.layer.masksToBounds = YES;
    
}

- (UILabel *)createSimpleLabelWithTitle:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)color {
    UILabel *lb = [[UILabel alloc] init];
    lb.text = title;
    lb.textColor = color;
    lb.font = [UIFont systemFontOfSize:font];
    return lb;
}

- (void)setItemModel:(YDSpaceRoomListItemModel *)itemModel {
    _itemModel = itemModel;
    [self.roomIv sd_setImageWithURL:[NSURL URLWithString:itemModel.roomImg]];
    self.nameL.text = [NSString stringWithFormat:@"%@币/次", itemModel.cost];
    UIColor *textColor;
    NSString *title;
    if(itemModel.status.integerValue == 1) {//火热中
        textColor = UIColor.redColor;
        title = @"热玩中";
    } else if (itemModel.status.integerValue == 2) {//维修中
        textColor = UIColor.grayColor;
        title = @"维修中";
    } else {//
        textColor = rgba(0, 231, 0, 1);
        title = @"空闲";
    }
    self.alertL.text = title;
    self.alertL.textColor = textColor;
    
}

@end
