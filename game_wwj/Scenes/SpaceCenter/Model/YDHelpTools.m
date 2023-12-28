//
//  YDHelpTools.m
//  game_wwj
//
//  Created by oneStep on 2023/11/30.
//

#import "YDHelpTools.h"

@implementation YDHelpTools

+ (CGFloat)getStatusBarHeight {
    float height = 0.0;
    if(@available(iOS 13.0, *)) {
        UIStatusBarManager *manager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        height = manager.statusBarFrame.size.height;
    } else {
        height = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return height;
}

@end
