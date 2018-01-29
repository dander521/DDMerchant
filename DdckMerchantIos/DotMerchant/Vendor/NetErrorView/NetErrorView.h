//
//  NetErrorView.h
//  iOS开发常见技术-每日一记
//
//  Created by Qian Shen on 2017/3/4.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NetErrorView;

@protocol NetErrorViewDelegate <NSObject>

@optional

-(void)reloadDataNetErrorView:(NetErrorView*)errorView;

@end

@interface NetErrorView : UIView

/**加载失败图片*/
@property (nonatomic, strong) UIImageView *statusImgView;
/** 返回按钮*/
@property (nonatomic, strong) UIButton *backBtn;
/**代理*/
@property (nonatomic, weak) id<NetErrorViewDelegate> delegate;

- (void)stopNetViewLoadingFail:(BOOL)fail error:(BOOL)error;

- (void)showAddedTo:(UIView *)view isClearBgc:(BOOL)isClearBgc;

@end
