//
//  TXWebView.h
//  TailorX
//
//  Created by 温强 on 2017/3/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// 页面开始加载时
typedef void(^DidStartBlcok)(WKNavigation *navigation);
// 内容开始返回时
typedef void(^DidCommitBlcok)(WKNavigation *navigation);
// 页面加载完成时
typedef void(^DidFinishBlcok)(WKNavigation *navigation,NSString *webTitle);
// 页面加载失败时
typedef void(^DidFailedBlcok)(WKNavigation *navigation);

@interface TXWebView : UIView

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, copy) DidStartBlcok didStart;
@property (nonatomic, copy) DidCommitBlcok didCommit;
@property (nonatomic, copy) DidFinishBlcok didFinish;
@property (nonatomic, copy) DidFailedBlcok didFailed;
- (instancetype)initWithFrame:(CGRect)frame;


@end
