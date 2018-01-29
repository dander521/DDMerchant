//
//  TXCustomTools.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCustomTools : NSObject


/**
 调起系统拨打电话

 @param phoneNo 电话号码
 */
+ (void)callStoreWithPhoneNo:(NSString *)phoneNo target:(UIViewController *)target;

/**
 设置alert按钮颜色

 @param color
 @param action
 */
+ (void)setActionTitleTextColor:(UIColor *)color action:(UIAlertAction *)action;

// 设置图片尺寸
+ (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


@end
