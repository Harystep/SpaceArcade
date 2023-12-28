//
//  YDSocketBackData.h
//  game_wwj
//
//  Created by oneStep on 2023/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDSocketBackData : NSObject

@property (nonatomic,copy) NSString *cmd;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *isGame;
@property (nonatomic,copy) NSString *remainSecond;
@property (nonatomic,copy) NSString *dollLogId;
@property (nonatomic,copy) NSString *vmc_no;
@property (nonatomic,copy) NSString *member_count;
@property (nonatomic,copy) NSString *points;
@property (nonatomic,copy) NSString *gold;
@property (nonatomic,copy) NSString *room_status;
@property (nonatomic,strong) NSArray *players;

@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) NSInteger appointmentCount;


@end

NS_ASSUME_NONNULL_END
