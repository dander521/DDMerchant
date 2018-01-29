//
//  DTNotification.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/24.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTNotification : NSObject

/** 注册成功 */
extern NSString * const kNotificationRegisterSuccess;
/** 登录成功 */
extern NSString * const kNotificationLoginSuccess;
/** 退出登录成功 */
extern NSString * const kNotificationLoginOutSuccess;
/** 添加商品成功 */
extern NSString * const kNotificationAddGoodsSuccess;
/** 上下架商品成功 */
extern NSString * const kNotificationGoodsOperateSuccess;
/** 回复评论成功 */
extern NSString * const kNotificationReplySuccess;

/** 支付宝付款成功 */
extern NSString *  const kNSNotificationAliPaySuccess;

/** 微信付款成功 */
extern NSString *  const kNSNotificationWXPaySuccess;

/** 微信付款失败 */
extern NSString *  const kNSNotificationWXPayFail;

/** 核销成功 */
extern NSString *  const kNSNotificationCheckSuccess;

extern NSString *  const kNSNotificationChangeGoodsOrCouponSuccess;

@end
