//
//  YDPushExchangeModel.h
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDPushExchangeModel : NSObject

@property (nonatomic,copy) NSString *goldCoin;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *points;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic, strong) NSString *chargeId;

@end

NS_ASSUME_NONNULL_END
