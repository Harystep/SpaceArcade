//
//  YDRechaegeFailView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import "YDSimpleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDRechaegeFailView : YDSimpleBaseView

@property (nonatomic,assign) BOOL status;

- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
