
#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYBBaseProcotolController : YDBaseViewController

@property (assign, nonatomic) NSInteger jumpBackType;
// 精度条颜色
@property (nonatomic, strong) UIColor  *progressColor;

@property (nonatomic,copy) NSString *urlStr;

@end

NS_ASSUME_NONNULL_END
