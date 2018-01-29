//
//  MBProgressHUD+CMKit.m
//  CMKit
//
//  Created by yons on 16/11/1.
//  Copyright © 2016年 yons. All rights reserved.
//

#import "MBProgressHUD+CMKit.h"
#import "UIImageView+WebCache.h"


@implementation MBProgressHUD (CMKit)


#pragma mark 信息显示
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }

    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: icon]];
    
//        FLAnimatedImageView *customView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        UIImage *image = [UIImage imageWithContentsOfFile:[NSFileManager getBundlePathForFile:@"请检查网络2.gif"]];
////        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
////        FLAnimatedImageView *customView = [[FLAnimatedImageView alloc] initWithFrame:rect];
//        customView.backgroundColor = [UIColor redColor];
//        NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"请检查网络2" withExtension:@"gif"];
//        [customView sd_setImageWithURL:bundleUrl];
//        hud.customView = customView;
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5];
}

#pragma mark 显示错误或正确信息
+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"MBProgressHUD+CMKit.bundle/error" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"MBProgressHUD+CMKit.bundle/success" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor blackColor];
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

/**
 *  显示信息
 *  @param text 信息内容
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor blackColor];
    // 1秒之后再消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
    // [hud hide:YES afterDelay:1.0];
}

/**
 显示信息

 @param text 信息内容
 @param view 显示的视图
 @param block 回调
 */
+ (void)show:(NSString *)text toView:(UIView *)view completionBlock:(void(^)())block
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor blackColor];
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
    hud.completionBlock = ^{
        if (block) {
            block();
        }
    };
}


@end
