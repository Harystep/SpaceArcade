//
//  ZCNetwork.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import "ZCNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZCSaveUserData.h"
#import "game_wwj-Swift.h"
#import "YDAESDataTool.h"
#import "GTMBase64.h"

#define MAINWINDOW  [UIApplication sharedApplication].keyWindow

#define kRequestUrlEncryptKey @"on"

@interface ZCNetwork ()

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, copy) NSString *host;

@end

static ZCNetwork *instanceManager = nil;

@implementation ZCNetwork

/** 重写 allocWithZone: 方法 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instanceManager == nil) {
            instanceManager = [super allocWithZone:zone];
            [instanceManager loadHost];
        }
    });
    return instanceManager;
}
/** 重写 copyWithZone: 方法 */
- (id)copyWithZone:(NSZone *)zone {
    
    return instanceManager;
}
/** 单例模式创建  */
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instanceManager) {
            instanceManager = [[self alloc] init];
        }
    });
    return instanceManager;
}

/**
 *  @brief  data 转 字典
 */
- (NSDictionary *)dataReserveForDictionaryWithData:(id)data {

    if ([kRequestUrlEncryptKey isEqualToString:@"on"]) {
        return [YDAESDataTool decryptResponseDictWithData:data];
    } else {
        if ([data isKindOfClass:[NSData class]]) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                                   error:nil];
            return dict;
        } else if ([data isKindOfClass:[NSDictionary class]]) {
            return data;
        } else {
            return nil;
        }
    }
}

- (NSDictionary *)dataToDict:(NSData *)data {
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
/**
 *  @brief  字典转json字符串方法
 *  @param dict 字典
 *  @return 字符串
 */
- (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError * error;
    // 字典转 data
    NSData  * jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
    NSString *jsonString;
    if (!jsonData) {
        
    }
    else {
        jsonString = [[NSString alloc]initWithData:jsonData
                                          encoding:NSUTF8StringEncoding];
        // 替换掉 url 地址中的 \/
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //去掉字符串中的空格
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "
                            withString:@""
                               options:NSLiteralSearch range:range];
    
    //去掉字符串中的换行符
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"
                            withString:@""
                               options:NSLiteralSearch range:range2];
    
    return mutStr;
}

#pragma mark : --
- (void)request_postWithApi:(NSString *)api
                    params:(nullable id)params
                    isNeedSVP:(BOOL)isNeed
                   success:(CompleteHandler)success
                    failed:(FaildureHandler)failed {
   
    //post 请求
    NSString *url = [self handleUrl:api];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"application/msexcel", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = responseSerializer;
    [manager POST:url parameters:params headers:[self headDic] progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self printRequestData:task reoponseObject:responseObject];
            [self handleResultWithModelClass:isNeed success:success failed:failed reponseObj:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error--->%@", error);            
        }];
    
}

- (NSString *)handleUrl:(NSString *)api {
    NSString *url;
    if (![api hasPrefix:@"http"]) {
        url = [[ZCNetwork shareInstance].host stringByAppendingString:api];
    } else {
        url = api;
    }
    return url;
}

- (void)request_getWithApi:(NSString *)api
                    params:(nullable id)params
                    isNeedSVP:(BOOL)isNeed
                   success:(CompleteHandler)success
                    failed:(FaildureHandler)failed {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 15.0;
    NSString *url = [self handleUrl:api];
    
    [self.sessionManager GET:url
                  parameters:params
                     headers:[self headDic]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [YDAESDataTool decryptData:[responseObject dataUsingEncoding:NSUTF8StringEncoding]];
        [self printRequestData:task reoponseObject:responseObject];
        
        [self handleResultWithModelClass:isNeed success:success failed:failed reponseObj:responseObject];
        
    }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
        
    }];
}



- (void)printRequestData:(NSURLSessionDataTask *)task reoponseObject:(id)obj{
    NSLog(@"---------------------------------------------");
    NSLog(@"\n\n🐱请求URL:%@\n🐱请求方式:%@\n🐱请求头信息:%@\n🐱请求正文信息:%@\n",task.originalRequest.URL,task.originalRequest.HTTPMethod,task.originalRequest.allHTTPHeaderFields,[[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
        NSString *responseJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\n✅success✅:\n%@\n\n", responseJson);
    }
    NSLog(@"---------------------------------------------");
}

- (void)handleResultWithModelClass:(BOOL)isNeed
                           success:(CompleteHandler)success
                            failed:(FaildureHandler)failed
                        reponseObj:(id)obj {
    // 成功，解析 respoObject
    NSDictionary *dict = [self dataReserveForDictionaryWithData:obj];
    if (dict) {
        // 判断后台返回的 code 是否为零
        if ([dict[@"errCode"] integerValue] == 0) {
            if([dict[@"code"] integerValue] == 500) {
                failed(dict);
            } else {
                success(dict);
            }
        } else {
            if([dict[@"errCode"] integerValue] == 401) {
                [self jumpLogoUI];
            } else {
                failed(dict);
            }
        }
    }
}

- (void)jumpLogoUI {
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kJumpLogoUIKey" object:window];
    });
    
}

- (void)loadHost {
#ifdef DEBUG   //http://192.168.50.95:8085/api/    http://192.168.0.115:8080/api
//    self.host = @"http://192.168.0.115:8080/api/";//k_Api_Host_Debug; k_Api_Host_Relase
    self.host = @"https://tbwz.yyzyxt.cn/api/";
#else
    self.host = @"https://tbwz.yyzyxt.cn/api/";
#endif
}

- (NSDictionary *)headDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([ZCSaveUserData getUserToken].length > 0) {        
        [dic setValue:[ZCSaveUserData getUserToken] forKey:@"accessToken"];
    }
    [dic setValue:@"tuibiwangzhe" forKey:@"channelKey"];
    [dic setValue:@"on" forKey:@"responseEncrypt"];
    [dic setValue:kRequestUrlEncryptKey forKey:@"requestUrlEncrypt"];
    return [dic copy];
}

// Lazy Load sessionManager
- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 20.f;
        [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [_sessionManager.requestSerializer didChangeValueForKey: @"timeoutInterval"];
        
        NSSet * set = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", nil];
        _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:set];
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        _sessionManager.requestSerializer  = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    }
    return _sessionManager;
}

@end
