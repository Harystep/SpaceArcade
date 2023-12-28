//
//  SYBBaseProcotolController.m
//  CashierChoke
//
//  Created by PC-N121 on 2022/9/27.
//  Copyright © 2022 zjs. All rights reserved.
//

#import "SYBBaseProcotolController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "ZCSaveUserData.h"

@interface SYBBaseProcotolController ()<WKNavigationDelegate,WKUIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *webProgress;
@property (nonatomic, assign, getter=isAllowZoomScale) BOOL allowZoomScale;
@end

@implementation SYBBaseProcotolController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    
    [self addConstrainsForSuper];
    
    [self queryProtocol];
    
    UIButton *back = [[UIButton alloc] init];
    [self.view addSubview:back];
    [back setImage:[UIImage imageNamed:@"icon_game_exit"] forState:UIControlStateNormal];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(5);
        make.top.mas_equalTo(self.view.mas_top).offset(35);
        make.height.width.mas_equalTo(50);
    }];
    [back addTarget:self action:@selector(backOp) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backOp {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- SetControlForSuper
- (void)createSubviews {
    [self.view addSubview:self.webView];
    
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper {
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset([YDHelpTools getStatusBarHeight]+44);
        make.leading.trailing.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    
}

- (void)queryProtocol {
    NSString *urlStr = [NSString stringWithFormat:@"http://camera.emugif.com/?token=%@", ZCSaveUserData.getUserToken];
   
    [self reloadWKWebViewWithURL:urlStr];
}

#pragma mark -- Target Methods
- (void)reloadWKWebViewWithURL:(NSString *)urlStr {
    
    NSURL        *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                              timeoutInterval:20];
    [self.webView loadRequest:request];
}

#pragma mark -- Private Methods
- (void)removeWebCache {
    
    if (@available(iOS 9.0, *)) {
        
        NSSet *websiteDataTypes= [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
                                                       //WKWebsiteDataTypeOfflineWebApplication
                                                        WKWebsiteDataTypeMemoryCache,
                                                        //WKWebsiteDataTypeLocal
                                                        WKWebsiteDataTypeCookies,
                                                        //WKWebsiteDataTypeSessionStorage,
                                                        //WKWebsiteDataTypeIndexedDBDatabases,
                                                        //WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        // All kinds of data
        // NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                   modifiedSince:dateFrom
                                               completionHandler:^{
                
        }];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
    }
    else {
        //先删除cookie
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        
        NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    // 清除缓存
    [self removeWebCache];
    
    [self.webView stopLoading];
    [self.webView removeFromSuperview];
    self.webView = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    
}

#pragma mark -- UITableView Delegate && DataSource

#pragma mark -- Other Delegate
// WKWebView Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    
    //开始加载网页时展示出webProgress
    //self.webProgress.hidden = NO;
    //开始加载网页的时候将webProgress的Height恢复为1.5倍
    self.webProgress.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止webProgress被网页挡住
    [self.view bringSubviewToFront:self.webProgress];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    
    //加载完成后隐藏webProgress
    //self.webProgress.hidden = YES;
    
    self.allowZoomScale = NO;
    
    //防止内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    //本地webkit硬盘图片的缓存；
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    //静止webkit离线缓存
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
            
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //加载失败同样需要隐藏webProgress
    //self.webProgress.hidden = YES;
//    webView.scrollView.emptyView = [[DNEmptyView alloc] init];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //加载失败同样需要隐藏webProgress
    //self.webProgress.hidden = YES;
//    webView.scrollView.emptyView = [[DNEmptyView alloc] init];
}

//urlEncode编码
- (NSString *)urlEncodeStr:(NSString *)input {
    NSString *charactersToEscape = @"[email protected]#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}
//urlEncode解码
- (NSString *)decoderUrlEncodeStr: (NSString *) input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}

- (void)backAction {
    if (self.jumpBackType) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        } else {
            //加上resignFirstResponder解决点击两次才能返回问题
            [self.view resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/// 通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"btnUploadFile"]) {
        NSLog(@"come - here");
    }
}

// 缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return !self.isAllowZoomScale ? nil : self.webView.scrollView.subviews.firstObject;
}

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
}

//- (UIProgressView *)webProgress {
//    if (!_webProgress) {
//        _webProgress = [[UIProgressView alloc] init];
//        // 设置进度条的背景颜色
//        _webProgress.progressTintColor = self.progressColor ? :[ZCConfigColor redColor];
//        _webProgress.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//    }
//    return _webProgress;
//}

- (WKWebView *)webView {
    
    if (!_webView) {

//        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript
//                                                         injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
//                                                      forMainFrameOnly:YES];
//
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addScriptMessageHandler:self name:@"btnUploadFile"];
////        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.selectionGranularity = YES; //允许与网页交互
        wkWebConfig.userContentController = wkUController;
        wkWebConfig.selectionGranularity = YES;
        wkWebConfig.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        wkWebConfig.allowsInlineMediaPlayback = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        _webView.UIDelegate = self;
        _webView.navigationDelegate  = self;
        // 手动设置缩放
        [_webView.scrollView setZoomScale:0.8 animated:NO];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _webView;
}

@end
