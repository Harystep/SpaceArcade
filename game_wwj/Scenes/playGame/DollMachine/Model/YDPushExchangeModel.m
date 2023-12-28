//
//  YDPushExchangeModel.m
//  game_wwj
//
//  Created by oneStep on 2023/11/28.
//

#import "YDPushExchangeModel.h"

@implementation YDPushExchangeModel

+(NSDictionary * )mj_replacedKeyFromPropertyName {
  return @{@"chargeId": @"id"};
}

@end
