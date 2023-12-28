//
//  YDPushPullStreamView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <WsRTC/WsRTCLive.h>


NS_ASSUME_NONNULL_BEGIN
@interface YDPushPullStreamView : UIView

@property (nonatomic, weak) WsRTCLiveView *pullView;

@property (nonatomic, strong) NSString *pullUrl;

- (void)loadBgVideoImageUrl:(NSString *)imageUrl;

- (void)loadFullImageUrl:(NSString *)imageUrl;

- (void)startPullUrl:(NSString *)pullUrl;

- (void)startPullUrlWithFFmpegAudio:(NSString *)pullUrl;

- (void)stopStreamVideo;

- (void)pullResume;

- (void)pullPause;

@end

NS_ASSUME_NONNULL_END
