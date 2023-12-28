//
//  HZPushPullVideoView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZPushPullVideoView : UIView

@property (nonatomic,copy) NSString *machineSn;

- (void)stopStream;

@end

NS_ASSUME_NONNULL_END
