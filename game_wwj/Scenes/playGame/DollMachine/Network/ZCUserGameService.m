//
//  ZCUserGameService.m
//  game_wwj
//
//  Created by oneStep on 2023/11/20.
//

#import "ZCUserGameService.h"
#import "ZCNetwork.h"
#import "ZCSaveUserData.h"
#import "YDAESDataTool.h"
#import "YDAlertView.h"

#define kEnterMachineRoomURL @"qjkK/PCl/EvYTPXrN+ptjA=="
#define kGetUserInfoURL @"Sw0QYosX4vG7dHcDQnI7Wg=="
#define kGetRechargeListInfoURL @"TuBvs5DJJnsFN+xTYynT0Iz8lxgDkZ1blso/l2YK2BI="
#define kGetPointsExchangeListURL @"9H8KLnSLz/ocbNwd8iO8hg=="
#define kExchangePointsOperateURL @"Cst1vvUnTpbE9A8rpnHP7fjDclCjKJAA/AwdT4g41CM="//
#define kCreateChargeOrderOpURL @"eMedQduoldxdiYgVcqHud4FapkrTJekfzIuSxPaMbL0="//
#define kPayChargeOrderByAppleURL @"qLbZIKfi/mGg/zvZDOvdD69b/zhDotbt2bgOPuKZh98="//
#define kGetRankListPointInfoURL @"dBlxPutUJAnxnQuYFcjrCC/RSXusGb2rRqnlb01twK0="
#define kGetRankListDiamondInfoURL @"h9Nvv8J/EBQbETtLdBBCt/3QdRImTxU7yYEUZoWTJXs="
#define kGetRoomListInfoURL @"UcPh211GnqyJY/KUEeYpSVnK5+4IYs7CcuYIJv9bFkY="
#define kGetSpaceWorkListInfoURL @"ID/7oQozQ/kjlYD+BuCyfQ=="
#define kReceiveSpaceWorkOpURL @"qF/lbD+CMIFC+RWUFbKYTnpRBjH/taosmT0sK3h3Tr4="//
#define kReceiveAllSpaceWorkOpURL @"c65IElUYzc0Ba/mv8zixdARdoCuFgGuAhNFpU22akgE="//
#define kGetSpaceMetalListInfoURL @"kcMA3xnjPHBD/z8oa5mNFHySwAbZiV67aXBjCBJ/cj0="//
#define kReceiveSpaceMetalOpInfoURL @"hCsO8NjAz2HY+oy214LkaI7xi68sQo4xyIagGtT5Z5k="//
#define kSendUserSignOpInfoURL @"TtkFkuDBqiwZzabiQ3ugDQ=="//
#define kDeleteAccountOpInfoURL @"3fa82zIa74bQCXnxWIvu+LzivAoizE23ioohbskPP6c="//

@implementation ZCUserGameService

+ (void)enterMachineRoomOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_postWithApi:kEnterMachineRoomURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

+ (void)getUserInfoOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];    
    [[ZCNetwork shareInstance] request_getWithApi:kGetUserInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getRechargeListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
//    NSString *url = [NSString stringWithFormat:@"%@?type=2", kGetRechargeListInfoURL];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    dic[@"type"] = @"2";
    [[ZCNetwork shareInstance] request_getWithApi:kGetRechargeListInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getPointsExchangeListURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_getWithApi:kGetPointsExchangeListURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//
+ (void)exchangePointsOperateURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_postWithApi:kExchangePointsOperateURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}
//
+ (void)createChargeOrderOpURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_postWithApi:kCreateChargeOrderOpURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            if ([data[@"errCode"] integerValue] == 500) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[YDAlertView sharedInstance] showTextMsg:data[@"errMsg"] dispaly:2.0];
                });
            }
        }
        completerHandler(data);
    }];
}

//
+ (void)payChargeOrderByAppleURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_postWithApi:kPayChargeOrderByAppleURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

+ (void)getRankListPointInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_getWithApi:kGetRankListPointInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getRankListDiamondInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_getWithApi:kGetRankListDiamondInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getRoomListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
//    NSString *url = [NSString stringWithFormat:@"%@", [YDAESDataTool encryptDataToString:kGetRoomListInfoURL]];
    [[ZCNetwork shareInstance] request_getWithApi:kGetRoomListInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
//        NSDictionary *temDic = @{@"name":@"Kitty"};
//        NSString *temStr = [self dictToJson:temDic];
//        NSData *oldData = [YDAESDataTool encryptData:[temStr dataUsingEncoding:NSASCIIStringEncoding]];
//        NSData *newData = [YDAESDataTool decryptData:oldData];
//        NSString *jsonStr = [[NSString alloc] initWithData:newData encoding:NSASCIIStringEncoding];        
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (NSDictionary *)dataToDict:(NSData *)data {
    // NSData转NSDictionary
    NSError *error;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
    if (error != nil) {
        NSLog(@"error--->%@", error);
    }
    return resultDic;
}

+ (NSString *)base64EncodedString:(NSString *)content {
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

// base64解码
+ (NSString *)base64DecodedString:(NSString *)content {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:content options:0];
    return [[NSString alloc]initWithData:data encoding: NSUTF8StringEncoding];
}

+ (NSString *)dictToJson:(NSDictionary *)dict {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (void)getSpaceWorkListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_getWithApi:kGetSpaceWorkListInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)receiveSpaceWorkListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_getWithApi:kReceiveSpaceWorkOpURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)receiveAllSpaceWorkListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_getWithApi:kReceiveAllSpaceWorkOpURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getSpaceMetalListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_getWithApi:kGetSpaceMetalListInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)receiveSpaceMetalOpInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_getWithApi:kReceiveSpaceMetalOpInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//
+ (void)sendUserSignOpInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_postWithApi:kSendUserSignOpInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//

+ (void)deleteAccountOpInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"accessToken"] = ZCSaveUserData.getUserToken;
    [[ZCNetwork shareInstance] request_postWithApi:kDeleteAccountOpInfoURL params:dic isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

@end
