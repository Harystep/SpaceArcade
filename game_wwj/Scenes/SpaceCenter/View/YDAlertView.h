

#import <UIKit/UIKit.h>
#import "YDSimpleBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDAlertView : UIView

+ (instancetype)sharedInstance;

- (void)showTextMsg:(NSString *)content;

- (void)showTextMsg:(NSString *)content dispaly:(NSInteger)secord;

@end

NS_ASSUME_NONNULL_END
