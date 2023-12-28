//
//  YDBaseViewController.h
//  game_wwj
//
//  Created by oneStep on 2023/11/29.
//

#import <UIKit/UIKit.h>
#import "YDApplePayModule.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry.h>
#import "YDSimpleBaseView.h"
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDBaseViewController : UIViewController

@property (nonatomic,copy) NSString *machineSn;

@property (nonatomic,assign) int machineType;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,strong) YDApplePayModule *applePayModule;

- (void)showLoadingToView:(UIView *)view;
- (void)hideLoadingToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
