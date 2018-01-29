//
//  ReachabilityUtil.h
//  iOS开发常见技术-每日一记
//
//  Created by Qian Shen on 2017/3/10.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ReachabilityUtil : NSObject


/**
 * 用AFNetworking获得当前网络 
 * 这个用于监听网络状态的改变
 */

+ (BOOL)getCurrentAFNetworkingState;

+ (BOOL)checkCurrentNetworkState;


@end
