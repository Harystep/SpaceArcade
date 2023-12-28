//
//  YDSpaceRoomListModel.h
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class YDSpaceRoomListItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface YDSpaceRoomListModel : NSObject

@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,copy) NSArray<YDSpaceRoomListItemModel *> *roomList;

@end

@interface YDSpaceRoomListItemModel : NSObject

@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *roomName;
@property (nonatomic,copy) NSString *roomImg;
@property (nonatomic,copy) NSString *machineId;
@property (nonatomic,copy) NSString *machineSn;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *machineType;
@property (nonatomic,copy) NSString *minLevel;
@property (nonatomic,copy) NSString *multiple;
@property (nonatomic,copy) NSString *minGold;
@property (nonatomic,copy) NSString *cost;


@end

NS_ASSUME_NONNULL_END
