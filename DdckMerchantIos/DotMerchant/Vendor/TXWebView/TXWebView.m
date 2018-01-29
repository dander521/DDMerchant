//
//  TXWebView.m
//  TailorX
//
//  Created by 温强 on 2017/3/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"

@interface TXWebView()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@end

@implementation TXWebView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self setupBaseView];
        
    }
    return self;
}

- (void)setRequestUrl:(NSString *)requestUrl {
    
    _requestUrl = requestUrl;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestUrl]]];
}

- (void)setupBaseView {
    
    // 用 js 来设置屏幕的比例
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"goCustom"];
    
    _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:wkWebConfig];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self addSubview:_webView];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    if (self.didStart) {
        self.didStart(navigation);
    }
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self animated:YES];
    if (self.didCommit) {
        self.didCommit(navigation);
    }
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self animated:YES];
    if (self.didFinish) {
        self.didFinish(navigation,webView.title);
    }

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self animated:YES];
    [ShowMessage showMessage:@"加载失败，请重试" withCenter:self.center];
    if (self.didFailed) {
        self.didFailed(navigation);
    }
}

#pragma mark
#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    if ([message.name isEqualToString:@"goCustom"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHtmlAppointmentDesigner object:nil userInfo:nil];
    }
}

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"goCustom"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
