//
//  YDSpaceRoomListModel.m
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import "YDSpaceRoomListModel.h"

@implementation YDSpaceRoomListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"groupId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"roomList":[YDSpaceRoomListItemModel class]
    };
}
@end


@implementation YDSpaceRoomListItemModel



@end
