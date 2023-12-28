//
//  YDExchangeAlertView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import "YDSimpleBaseView.h"
#import "YDPushExchangeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDExchangeAlertView : YDSimpleBaseView

@property (nonatomic,strong) YDPushExchangeModel *model;
@property (nonatomic,copy) void (^sureExchangeBlock) (void);
- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
