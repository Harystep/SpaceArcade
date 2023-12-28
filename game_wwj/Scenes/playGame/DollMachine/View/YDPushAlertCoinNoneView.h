//
//  YDPushAlertCoinNoneView.h
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import "YDSimpleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDPushAlertCoinNoneView : YDSimpleBaseView

@property (nonatomic,copy) void (^sureRechargeBlock)(void);

- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
