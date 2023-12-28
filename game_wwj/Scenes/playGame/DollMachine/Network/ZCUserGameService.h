//
//  ZCUserGameService.h
//  game_wwj
//
//  Created by oneStep on 2023/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCUserGameService : NSObject

+ (void)enterMachineRoomOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getUserInfoOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getRechargeListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getPointsExchangeListURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)exchangePointsOperateURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)createChargeOrderOpURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)payChargeOrderByAppleURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getRankListPointInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getRankListDiamondInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getRoomListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getSpaceWorkListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)receiveSpaceWorkListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)receiveAllSpaceWorkListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getSpaceMetalListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)receiveSpaceMetalOpInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)sendUserSignOpInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)deleteAccountOpInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

@end

NS_ASSUME_NONNULL_END
