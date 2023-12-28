

#import "YDAlertView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kMarX 16.0

@interface YDAlertView ()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UILabel *titleL;

@end

static YDAlertView *_instance;

@implementation YDAlertView


+ (YDAlertView *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YDAlertView alloc] init];
    });
    return _instance;
}

- (void)showTextMsg:(NSString *)content {
    [self showTextMsg:content dispaly:5.0];
}

- (void)showTextMsg:(NSString *)content dispaly:(NSInteger)secord {
    if([self judgeStringVail:content]) {
        return;
    }
    _instance.hidden = NO;
    _instance.backgroundColor = UIColor.whiteColor;
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = kBoldFont(14);
    titleL.textColor = [UIColor grayColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.numberOfLines = 0;
    titleL.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize contentSize = [self compareContentSize:content withFont:15 widthLimited:(kWidth - 30 * 2)];
    titleL.text = content;
    [_instance addSubview:titleL];
    
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    [win addSubview:_instance];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        titleL.frame = CGRectMake(4, 10, contentSize.width + 4, contentSize.height + 4);
        _instance.frame = CGRectMake((kWidth - contentSize.width - 4 - 8)/2, 60, contentSize.width + 4 + 8, contentSize.height + 24);
        _instance.layer.cornerRadius = (contentSize.height + 24)/2.0;
        _instance.layer.masksToBounds = YES;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secord * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [titleL removeFromSuperview];
        _instance.hidden = YES;
    });
}

- (CGSize)compareContentSize:(NSString *)title withFont:(CGFloat)font widthLimited:(CGFloat)limitWidth{
    UIFont *fnt = [UIFont systemFontOfSize:font];
    CGSize postJobSize = [title boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil].size;
    return postJobSize;
}

- (BOOL)judgeStringVail:(NSString *)content {
    if ([content isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
