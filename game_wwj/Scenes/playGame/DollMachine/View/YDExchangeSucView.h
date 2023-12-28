//
//  YDExchangeSucView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import "YDSimpleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDExchangeSucView : YDSimpleBaseView
@property (nonatomic,assign) NSInteger status;
- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
