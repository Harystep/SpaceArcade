//
//  YDSimpleBaseView.h
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <SDWebImage.h>
#import "UIResponder+Router.h"
#import "YDHelpTools.h"
#import <MJExtension/MJExtension.h>

#define rgba(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kImage(content) [UIImage imageNamed:content]
#define kFont(font) [UIFont systemFontOfSize:font]
#define kBoldFont(font) [UIFont boldSystemFontOfSize:font]
#define kCustomFont(font) [UIFont fontWithName:@"ZhenyanGB" size:font]

// 刘海屏适配判断
#define STATUS_H          [YDHelpTools getStatusBarHeight]
#define iPhone_X ((UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (STATUS_H > 20.0))
#define STATUS_BAR_HEIGHT (iPhone_X ? 44.f : 20.f)

NS_ASSUME_NONNULL_BEGIN

@interface YDSimpleBaseView : UIView

- (UIButton *)createSimpleBtnWithTitle:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)color;

- (UILabel *)createSimpleLabelWithTitle:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)color;


@end

NS_ASSUME_NONNULL_END
