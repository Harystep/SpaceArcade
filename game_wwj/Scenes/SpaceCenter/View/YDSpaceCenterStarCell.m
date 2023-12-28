//
//  YDSpaceCenterStarCell.m
//  game_wwj
//
//  Created by oneStep on 2023/11/30.
//

#import "YDSpaceCenterStarCell.h"
#import "YDSpaceSimpleStarView.h"
#import "YDSpaceStarRoomItemCell.h"
#import "YDAlertView.h"

@interface YDSpaceCenterStarCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) YDSpaceSimpleStarView *starView;

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation YDSpaceCenterStarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    self.starView = [[YDSpaceSimpleStarView alloc] init];
    [self.contentView addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.height.mas_equalTo(244);
        make.top.mas_equalTo(self.contentView.mas_top);
    }];
    self.starView.starName = @"space_fire_star_icon";
       
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(10);
        make.top.mas_equalTo(self.starView.mas_bottom).offset(5);
        make.height.mas_equalTo(66);
    }];
    
    //
    
    UIImageView *leftIv = [[UIImageView alloc] initWithImage:kImage(@"space_center_room_left")];
    [self.contentView addSubview:leftIv];
    [leftIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.collectionView).offset(-8);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(-5);
    }];
    
    UIImageView *rightIv = [[UIImageView alloc] initWithImage:kImage(@"space_center_room_right")];
    [self.contentView addSubview:rightIv];
    [rightIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.collectionView).offset(-8);
        make.leading.mas_equalTo(self.collectionView.mas_trailing);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.roomList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    YDSpaceStarRoomItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDSpaceStarRoomItemCell" forIndexPath:indexPath];
    cell.itemModel = self.model.roomList[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(50, 66);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YDSpaceRoomListItemModel *model = self.model.roomList[indexPath.row];
    NSDictionary *dic = @{@"machineSn":model.machineSn, @"machineType":model.machineType};
    if(model.status.integerValue == 2) {
        [[YDAlertView sharedInstance] showTextMsg:@"设备维护中···" dispaly:2.0];
    } else {
        [self routerWithEventName:@"jumpGame" userInfo:dic];
    }
}

- (void)setModel:(YDSpaceRoomListModel *)model {
    _model = model;
    NSString *imageStr;
    if([model.groupName isEqualToString:@"木星"]) {
        imageStr = @"space_reward_star_4";
    } else if ([model.groupName isEqualToString:@"金星"]) {
        imageStr = @"space_reward_star_2";
    } else if ([model.groupName isEqualToString:@"水星"]) {
        imageStr = @"space_reward_star_1";
    } else if ([model.groupName isEqualToString:@"火星"]) {
        imageStr = @"space_reward_star_8";
    } else if ([model.groupName isEqualToString:@"土星"]) {
        imageStr = @"space_reward_star_6";
    } else if ([model.groupName isEqualToString:@"天王星"]) {
        imageStr = @"space_reward_star_3";
    } else if ([model.groupName isEqualToString:@"海王星"]) {
        imageStr = @"space_reward_star_7";
    } else {
        imageStr = @"space_reward_star_5";
    }
    self.starView.starName = imageStr;
    self.starView.titleL.text = [NSString stringWithFormat:@"%@", model.groupName];
    
    [self.collectionView reloadData];
}

#pragma mark - lazy UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
        flowLayot.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayot];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 6, 0, 6);        
        [_collectionView registerClass:[YDSpaceStarRoomItemCell class] forCellWithReuseIdentifier:@"YDSpaceStarRoomItemCell"];
    }
    return _collectionView;
}

@end
