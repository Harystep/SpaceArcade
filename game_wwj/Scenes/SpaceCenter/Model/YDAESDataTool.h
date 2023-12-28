//
//  YDAESDataTool.h
//  DemoWeb
//
//  Created by oneStep on 2023/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDAESDataTool : NSObject

+ (NSString *)encryptDataToString:(NSString *)dataStr;

+ (NSData *)responseDecryptData:(NSData *)data;

+ (NSDictionary *)decryptResponseDictWithData:(id)data;

//+ (void)convertUrls;

@end

NS_ASSUME_NONNULL_END
