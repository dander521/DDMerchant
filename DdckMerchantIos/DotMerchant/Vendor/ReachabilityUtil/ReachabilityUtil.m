//
//  ReachabilityUtil.m
//  iOS开发常见技术-每日一记
//
//  Created by Qian Shen on 2017/3/10.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import "ReachabilityUtil.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NSString+Extension.h"

@implementation ReachabilityUtil

+ (BOOL)getCurrentAFNetworkingState {
    /**
     * 这个网络请求状态获取非常准确，每次改变网络都能准确的监听。
     */
    __block NSString *netState;
    __block BOOL state = YES;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                state = NO;
                netState = @"";
            }
            break;
            case AFNetworkReachabilityStatusNotReachable: {
                state = YES;
                netState = @"当前网络未连接，请检查网络";
            }
            break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                state = YES;
                netState = @"";
            }
            break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                state = YES;
                netState = @"";
            }
            break;
        }
        if (![NSString isTextEmpty:netState]) {
            [self show:netState];
        }
    }];
    [manager startMonitoring];
    return state;
}

+ (BOOL)checkCurrentNetworkState {
    /**
     * 这个网络请求状态获取非常准确，每次改变网络都能准确的监听。
     */
    __block BOOL state = YES;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                state = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                state = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                state = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                state = YES;
                break;
        }
    }];
    [manager startMonitoring];
    return state;
}

+ (void)show:(NSString *)text
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.margin = 15;
    //hud.alpha = 0.5;
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor blackColor];
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
}




@end
