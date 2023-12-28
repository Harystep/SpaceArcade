//
//  YDSpaceMetalImage.h
//  game_wwj
//
//  Created by oneStep on 2023/12/4.
//

#import <UIKit/UIKit.h>
#import "YDSimpleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDSpaceMetalImage : UIView

@property (nonatomic,strong) UIImageView *starIv;

@property (nonatomic,assign) int receiveStatus;

@property (nonatomic,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
