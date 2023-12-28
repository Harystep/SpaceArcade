//
//  UIResponder+Router.m
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo block:(void (^)(id result))block {
    if (self.nextResponder) {
        [[self nextResponder] routerWithEventName:eventName userInfo:userInfo block:block];
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if (self.nextResponder) {
        [[self nextResponder] routerWithEventName:eventName userInfo:userInfo];
    }
}

- (void)routerWithEventName:(NSString *)eventName {
    if (self.nextResponder) {
        [[self nextResponder] routerWithEventName:eventName];
    }
}

@end
