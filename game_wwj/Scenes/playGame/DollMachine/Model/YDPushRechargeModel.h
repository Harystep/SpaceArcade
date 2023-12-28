//
//  YDPushRechargeModel.h
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDPushRechargeModel : NSObject

@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *iosOption;
@property (nonatomic,copy) NSString *mark;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *profitRate;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *type;
@property (nonatomic, strong) NSString * chargeId;
@property (nonatomic,copy) NSString *dayMoney;

@property (nonatomic,copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
