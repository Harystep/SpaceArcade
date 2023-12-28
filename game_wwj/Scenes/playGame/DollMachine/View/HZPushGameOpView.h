//
//  HZPushGameOpView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import <UIKit/UIKit.h>
#import "UIResponder+Router.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZPushGameOpView : UIView

@property (nonatomic,assign) NSInteger status;

@property (nonatomic,assign) BOOL startFlag;

@property (nonatomic,assign) BOOL refreshCount;

@property (nonatomic,assign) NSInteger appointCount;

- (void)stopDownCountTimer;

@end

NS_ASSUME_NONNULL_END
