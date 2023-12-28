//
//  YDSimpleBaseView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import "YDSimpleBaseView.h"

@implementation YDSimpleBaseView

- (UIButton *)createSimpleBtnWithTitle:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)color {
   
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    return btn;
}

- (UILabel *)createSimpleLabelWithTitle:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)color {
    UILabel *lb = [[UILabel alloc] init];
    lb.text = title;
    lb.textColor = color;
    lb.font = [UIFont systemFontOfSize:font];
    return lb;
}

@end
