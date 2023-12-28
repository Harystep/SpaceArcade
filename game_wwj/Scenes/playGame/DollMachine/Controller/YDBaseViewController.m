//
//  YDBaseViewController.m
//  game_wwj
//
//  Created by oneStep on 2023/11/29.
//

#import "YDBaseViewController.h"

@interface YDBaseViewController ()

@end

@implementation YDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.applePayModule = [YDApplePayModule sharedInstance];
}

- (void)showLoadingToView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:true];
    });
}
- (void)hideLoadingToView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:true];
    });
}

@end
