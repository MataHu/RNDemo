//
//  CashWKWebViewController.h
//  Cash
//
//  Created by 胡佳俊 on 2017/11/16.
//  Copyright © 2017年 陈浩停. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashWKWebViewController : UIViewController

- (instancetype)initWithURL:(NSURL *)url;

- (instancetype)initWithURLString:(NSString *)urlString;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

@property (nonatomic, copy) UIColor *loadingBarTintColor;

@property (nonatomic, assign) BOOL hideWebViewBoundaries;

@end
