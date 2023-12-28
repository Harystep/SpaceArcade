//
//  YDPushExchangeAlertView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import "YDSimpleBaseView.h"
#import "YDPushExchangeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDPushExchangeAlertView : YDSimpleBaseView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,copy) void (^selectExchangeItemBlock)(YDPushExchangeModel *model);

- (void)showAlertView;

- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
