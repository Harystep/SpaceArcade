//
//  YDPushRechargePackCardCell.h
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import <UIKit/UIKit.h>
#import "YDPushRechargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDPushRechargePackCardCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *bgIcon;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) YDPushRechargeModel *model;

@end

NS_ASSUME_NONNULL_END
