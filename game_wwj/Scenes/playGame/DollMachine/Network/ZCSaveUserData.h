//
//  ZCSaveUserData.h
//  game_wwj
//
//  Created by oneStep on 2023/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSaveUserData : NSObject

+ (void)saveUserToken:(NSString *)token;
+ (NSString *)getUserToken;

+ (BOOL)judgeLoginStatus;

@end

NS_ASSUME_NONNULL_END
