//
//  UIResponder+Router.h
//  game_wwj
//
//  Created by oneStep on 2023/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Router)

/**
 发送路由消息 -- 调用后在对应的控制器重写改方法

 @param eventName 发生事件名称
 @param userInfo 传递消息携带的数据
 @param block 传递消息产生的回调
 */
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo block:(void (^)(id result))block;

/**
 发送路由消息
 
 @param eventName 发生事件名称
 @param userInfo 传递消息携带的数据
 */
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

/**
 发送路由消息
 
 @param eventName 发生事件名称
 */
- (void)routerWithEventName:(NSString *)eventName;

@end

NS_ASSUME_NONNULL_END
