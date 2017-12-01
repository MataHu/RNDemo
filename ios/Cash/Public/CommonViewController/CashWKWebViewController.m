//
//  CashWKWebViewController.m
//  Cash
//
//  Created by 胡佳俊 on 2017/11/16.
//  Copyright © 2017年 陈浩停. All rights reserved.
//

#import "CashWKWebViewController.h"
#import <WebKit/WebKit.h>

#define MINIMAL_UI           \
([[UIViewController class] \
instancesRespondToSelector:@selector(edgesForExtendedLayout)])

@interface CashWKWebViewController ()<UIGestureRecognizerDelegate, WKNavigationDelegate, WKUIDelegate>

/* The main view components of the controller */
@property (nonatomic, strong, readwrite) WKWebView *webView;        /* The web view, where all the magic happens */
//@property (nonatomic, strong) NJKWebViewProgressView *progressView; /* A bar that tracks the load progress of the current page. */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;       /* Gradient effect for the background view behind the web view. */
@property (nonatomic, copy) NSURL *currentURL;
@property (nonatomic, copy) NSURL *urlToBeReload;
- (void)setup;
- (NSURL *)cleanURL:(NSURL *)url;
@end

// -------------------------------------------------------

#pragma mark - Class Implementation -
@implementation CashWKWebViewController

#pragma mark - Class Creation
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self setup];
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
        [self setup];
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init])
        _url = [self cleanURL:url];
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

#pragma mark - Setup
- (NSURL *)cleanURL:(NSURL *)url {
    // If no URL scheme was supplied, defer back to HTTP.
    if (url.scheme.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [url absoluteString]]];
    }
    return url;
}

- (void)setup {
    // Set the initial default style as full screen (But this can be easily overridden)
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    // Set the URL request
    self.urlRequest = [[NSMutableURLRequest alloc] init];
}

- (void)loadView {
    // Create the all-encompassing container view
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    view.backgroundColor = (self.hideWebViewBoundaries ? [UIColor whiteColor] : [UIColor whiteColor]);
#pragma clang diagnostic pop
    view.opaque = YES;
    view.clipsToBounds = YES;
    self.view = view;
    // create and add the detail gradient to the background view
    if (MINIMAL_UI == NO) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[
                                      (id)[[UIColor colorWithWhite:0.0f alpha:0.0f] CGColor],
                                      (id)[[UIColor colorWithWhite:0.0f alpha:0.35f] CGColor]
                                      ];
        self.gradientLayer.frame = self.view.bounds;
        [self.view.layer addSublayer:self.gradientLayer];
    }
    // Create the web view
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.hideWebViewBoundaries)
        self.gradientLayer.hidden = YES;
   
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
}

#pragma mark - View Presentation/Dismissal

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.gradientLayer.frame = self.view.bounds;
    self.navigationItem.backBarButtonItem = nil;
    
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // start loading the initial page
    
    if (self.url && self.webView.URL == nil) {
        [self.urlRequest setURL:self.url];
        [self.webView loadRequest:self.urlRequest];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark -
#pragma mark Manual Property Accessors
- (void)setUrl:(NSURL *)url {
    if (self.url == url)
        return;
    _url = [self cleanURL:url];
    if (self.webView.loading)
        [self.webView stopLoading];
    [self.urlRequest setURL:self.url];
    [self.webView loadRequest:self.urlRequest];
    self.currentURL = self.url;
}

- (void)setLoadingBarTintColor:(UIColor *)loadingBarTintColor {
    if (loadingBarTintColor == _loadingBarTintColor) {
        return;
    }
    
    _loadingBarTintColor = loadingBarTintColor;
    
//    if (self.progressView) {
//        self.progressView.progressBarView.backgroundColor = _loadingBarTintColor;
//    }
}

#pragma mark WebView Delegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
// 显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSString *title = [NSString stringWithFormat:@"来自%@的提示", frame.request.URL.host];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController
                       animated:YES
                     completion:^{
                     }];
}
// 弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *__nullable result))completionHandler {
}
// 显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSString *title = [NSString stringWithFormat:@"来自%@的提示", frame.request.URL.host];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             completionHandler(NO);
                                                         }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              completionHandler(YES);
                                                          }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
   
}
// WKNavigation导航错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    self.urlToBeReload = (navigationAction.navigationType == WKNavigationTypeBackForward) ? navigationAction.request.URL : nil;
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    
    BOOL shouldStart = YES;
    // If a request handler has been set, check to see if we should go ahead
    
    NSString *url = [NSString stringWithFormat:@"%@", navigationAction.request.URL];
    if ([url containsString:@"wvjbscheme://"]) {
        shouldStart = NO;
    }
    
    if (shouldStart) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)backButtonTapped:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
