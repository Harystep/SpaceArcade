//
//  ZCSaveUserData.m
//  game_wwj
//
//  Created by oneStep on 2023/11/20.
//

#import "ZCSaveUserData.h"

@implementation ZCSaveUserData

+ (void)saveUserToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"kSaveUserTokenKey"];
}

+ (NSString *)getUserToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kSaveUserTokenKey"];
}

+ (BOOL)judgeLoginStatus {
    BOOL status = NO;
    if([self getUserToken].length > 0) {
        status = YES;
    } else {
        status = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kJumpLogoUIKey" object:nil];
    }
    return status;
}

@end
