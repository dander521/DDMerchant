//
//  UIImage+Extension.h
//  Tailorx
//
//  Created by 高习泰 on 16/8/10.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  生成的图片的rect默认为100,100
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithTheColor:(UIColor *)color;
@end
