//
//  YDPushRechargeAlertView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import "YDSimpleBaseView.h"
#import "YDPushRechargeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDPushRechargeAlertView : YDSimpleBaseView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,copy) void (^selectRechargeItemBlock)(YDPushRechargeModel *model);

- (void)showRechargeView;

- (void)hideRechargeView;

@end

NS_ASSUME_NONNULL_END
