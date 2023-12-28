//
//  YDSpaceWorkItemCell.h
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import <UIKit/UIKit.h>
#import "YDSimpleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDSpaceWorkItemCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)spaceWorkItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
