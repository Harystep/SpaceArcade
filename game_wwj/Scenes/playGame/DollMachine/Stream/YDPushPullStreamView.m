//
//  YDPushPullStreamView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import "YDPushPullStreamView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface YDPushPullStreamView () <WsRTCLiveViewDelegate>
@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, assign) BOOL voiceFlag;
@end
@implementation YDPushPullStreamView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.voiceFlag = false;
    [self bgImageView];
  }
  return self;
}
#pragma mark - public
- (void)loadBgVideoImageUrl:(NSString * )imageUrl {
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize imageSize = image.size;
        CGFloat imageOption = 4.0f / 3.0f;
        CGFloat imageHeight = self.frame.size.width / imageOption;
        self.bgImageView.image = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bgImageView.frame = CGRectMake(0, -(imageHeight - self.frame.size.height) /2.0f, self.frame.size.width, imageHeight);
        });
  }];
}

- (void)loadFullImageUrl:(NSString * )imageUrl {
  self.bgImageView.contentMode = UIViewContentModeScaleToFill;
  [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)startPullUrl:(NSString *)pullUrl {
  _pullUrl = pullUrl;
  self.pullView.streamUrl = self.pullUrl;
  [self.pullView startplay];
}
- (void)startPullUrlWithFFmpegAudio:(NSString *)pullUrl {
  self.voiceFlag = true; //推流是否静音
  [self startPullUrl:pullUrl];
}
- (void)stopStreamVideo {
  [self.pullView stop];
}

- (void)pullPause {
    [self.pullView pause];
}

- (void)pullResume {
//    [self.vidoeView setAudioMute:true];
    [self.pullView restart];
}
#pragma mark - WsRTCLiveViewDelegate
- (void)videoView:(WsRTCLiveView *)videoView didError:(NSError *)error {
  NSLog(@"videoView didError: %@", error);
}
- (void)videoView:(WsRTCLiveView *)videoView didChangeVideoSize:(CGSize)size {
}
- (void)onConnected:(WsRTCLiveView *)videoView {
  if (self.voiceFlag) {
    [videoView setAudioMute:true];
  }
}
#pragma mark - lazy weak View
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self addSubview:theView];
        theView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView = theView;
    }
    return _bgImageView;
}

- (WsRTCLiveView *)pullView{
    if (!_pullView) {
        WsRTCLiveView *liveView = [[WsRTCLiveView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) audioforamt:WsRTCAudio_AAC_LATM encrypt:false];
        [self addSubview:liveView];
        liveView.delegate = self;
        [liveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _pullView = liveView;
    }
    return _pullView;
}

@end
