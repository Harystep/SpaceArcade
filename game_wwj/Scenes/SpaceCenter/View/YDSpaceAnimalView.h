//
//  YDSpaceAnimalView.h
//  game_wwj
//
//  Created by oneStep on 2023/12/5.
//

#import <UIKit/UIKit.h>
#import "YDSimpleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDSpaceAnimalView : UIImageView

@property (nonatomic,strong) UIImageView *iconIv;

- (void)startStartAnimal;
- (void)stopStartAnimal;

@end

NS_ASSUME_NONNULL_END
