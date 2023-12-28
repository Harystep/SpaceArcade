//
//  HZDollGameController.h
//  game_wwj
//
//  Created by oneStep on 2023/11/16.
//

#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZPushGameController : YDBaseViewController

@property (nonatomic,copy) NSString *addressUrl;

@property (nonatomic,assign) int port;

@property (nonatomic,assign) int minGold;

@end

NS_ASSUME_NONNULL_END
