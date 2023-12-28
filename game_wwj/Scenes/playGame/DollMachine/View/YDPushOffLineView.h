//
//  YDPushOffLineView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import "YDSimpleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDPushOffLineView : YDSimpleBaseView

@property (nonatomic,copy) void (^sureOfflineBlock)(void);

@property (nonatomic,copy) NSString *title;

- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
