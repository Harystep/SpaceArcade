#import <Foundation/Foundation.h>

typedef void (^ApplyPayBlock) (NSString * _Nullable receipt);
typedef void (^ApplePayFailBlock) (NSString * _Nonnull errMessage);

NS_ASSUME_NONNULL_BEGIN

@interface YDApplePayModule : NSObject

@property (nonatomic,copy) ApplyPayBlock payBlock;
@property (nonatomic,copy) ApplePayFailBlock payFailBlock;

+ (instancetype)sharedInstance;

- (void)finishTransactionForAp;

- (void)clearAllUncompleteTransaction:(ApplyPayBlock)block;

- (void)pay:(NSString *)projectId withOrderId:(NSString *)oriderId orderSn:(NSString *)orderSn withBlock:(ApplyPayBlock)block withFaileBlock:(ApplePayFailBlock)failBlock;

@end
NS_ASSUME_NONNULL_END
