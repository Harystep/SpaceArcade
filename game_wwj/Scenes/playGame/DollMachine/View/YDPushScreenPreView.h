//
//  YDPushScreenPreView.h
//  game_wwj
//
//  Created by appleplay on 2023/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YDPushScreenPreViewDelegate <NSObject>

- (void)loadFinished;

@end

@interface YDPushScreenPreView : UIView

@property (nonatomic, weak) id<YDPushScreenPreViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
