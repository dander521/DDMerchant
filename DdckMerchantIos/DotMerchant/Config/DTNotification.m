//
//  DTNotification.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/24.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTNotification.h"

@implementation DTNotification

/** 注册成功 */
NSString * const kNotificationRegisterSuccess = @"kNotificationRegisterSuccess";
/** 登录成功 */
NSString * const kNotificationLoginSuccess = @"kNotificationLoginSuccess";
/** 退出登录成功 */
NSString * const kNotificationLoginOutSuccess = @"kNotificationLoginOutSuccess";
/** 添加商品成功 */
NSString * const kNotificationAddGoodsSuccess = @"kNotificationAddGoodsSuccess";
/** 上下架商品成功 */
NSString * const kNotificationGoodsOperateSuccess = @"kNotificationGoodsOperateSuccess";
/** 回复评论成功 */
NSString * const kNotificationReplySuccess = @"kNotificationReplySuccess";

/** 支付宝付款成功 */
NSString *  const kNSNotificationAliPaySuccess = @"kNSNotificationAliPaySuccess";
/** 微信付款成功 */
NSString *  const kNSNotificationWXPaySuccess = @"kNSNotificationWXPaySuccess";
/** 微信付款成功 */
NSString *  const kNSNotificationWXPayFail = @"kNSNotificationWXPayFail";
/** 核销成功 */
NSString *  const kNSNotificationCheckSuccess = @"kNSNotificationCheckSuccess";
NSString *  const kNSNotificationChangeGoodsOrCouponSuccess = @"kNSNotificationChangeGoodsOrCouponSuccess"; 

@end
