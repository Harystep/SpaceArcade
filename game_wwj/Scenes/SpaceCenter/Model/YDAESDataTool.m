//
//  YDAESDataTool.m
//  DemoWeb
//
//  Created by oneStep on 2023/12/15.
//

#import "YDAESDataTool.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation YDAESDataTool

+ (void)testFun {
    NSString *originalString = @"Hello, World!";
    
    NSData *originalData = [originalString dataUsingEncoding:NSUTF8StringEncoding];
    // 加密
    NSData *encryptedData = [self encryptData:originalData];
    
    // 解密
    NSData *decryptedData = [self decryptData:encryptedData];

    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];

    NSLog(@"Decrypted String: %@", decryptedString);
}

//+ (void)convertUrls {
//   
//    for (NSString *item in urls) {
//        [self encryptDataToString:item];
//    }
//}

+ (NSString *)encryptDataToString:(NSString *)dataStr {
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *content;
    NSData *encryptData = [self encryptData:data];
    content = [GTMBase64 stringByEncodingData:encryptData];
    NSLog(@"encryptDataToString>>>> %@<--------------->%@", dataStr, content);
    return content;
}

// 加密
+ (NSData *)encryptData:(NSData *)data {
    NSString *key = @"WWJ_2023_$#@!123";
    NSString *iv = @"ABCDEFGHIJKLMNOP";
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

// 解密
+ (NSData *)decryptData:(NSData *)data {
    NSString *key = @"WWJ_2023_$#@!123";
    NSString *iv = @"ABCDEFGHIJKLMNOP";
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

+ (NSDictionary *)decryptResponseDictWithData:(id)data {
    if ([data isKindOfClass:[NSData class]]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                               error:nil];
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        NSData *contentData = [GTMBase64 decodeString:temDic[@"data"]];
        NSData *data = [YDAESDataTool decryptData:contentData];
        temDic[@"data"] = [self dataToDict:data];
        return temDic;
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:data];
        NSData *contentData = [GTMBase64 decodeString:temDic[@"data"]];
        NSData *data = [YDAESDataTool decryptData:contentData];
        temDic[@"data"] = [self dataToDict:data];
        return temDic;
    } else {
        return nil;
    }
}

+ (NSData *)responseDecryptData:(NSData *)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                           error:nil];
    NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSData *contentData = [GTMBase64 decodeString:temDic[@"data"]];
    NSData *decryptData = [self decryptData:contentData];
    temDic[@"data"] = [self dataToDict:decryptData];
    NSLog(@"temDic--->%@", temDic);
    return [self convertDataWitnDict:temDic];
}

+ (NSData *)convertDataWitnDict:(NSDictionary *)dic {
    return [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
}

+ (NSDictionary *)dataToDict:(NSData *)data {
    // NSData转NSDictionary
    NSError *error;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
    if (error != nil) {
        NSLog(@"error--->%@", error);
    }
    return resultDic;
}

@end
