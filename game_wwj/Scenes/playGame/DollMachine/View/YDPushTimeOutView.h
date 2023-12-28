//
//  YDPushTimeOutView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/29.
//

#import "YDSimpleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDPushTimeOutView : YDSimpleBaseView

@property (nonatomic,copy) void (^sureOfflineBlock)(void);

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *title;

- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
