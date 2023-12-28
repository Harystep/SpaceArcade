//
//  HZPushPullVideoView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import "HZPushPullVideoView.h"
#import "YDPushPullStreamView.h"
#import <Masonry/Masonry.h>

@interface HZPushPullVideoView ()

@property (nonatomic,strong) YDPushPullStreamView *pullView;

@end

@implementation HZPushPullVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.pullView = [[YDPushPullStreamView alloc] init];
    [self addSubview:self.pullView];
    [self.pullView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
//    self.machineSn = @"";
}

- (void)setMachineSn:(NSString *)machineSn {
    _machineSn = machineSn;
    NSString *playUrl = [NSString stringWithFormat:@"http://play-test.ssjww100.com/live/wwj_zego_stream_%@.sdp", machineSn];
    [self.pullView startPullUrlWithFFmpegAudio:playUrl];
}

- (void)stopStream {
    [self.pullView stopStreamVideo];
}

@end
