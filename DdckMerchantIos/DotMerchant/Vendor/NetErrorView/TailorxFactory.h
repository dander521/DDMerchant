//
//  TailorxFactory.h
//  Tailorx
//
//  Created by 高习泰 on 16/7/29.
//  Copyright © 2016年   高习泰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
@interface TailorxFactory : NSObject
+ (UILabel *)setLabWithText:(NSString *)text textColor:(UIColor *)textColor fontType:(UIFont *)fontdType superView:(UIView *)superView;

+ (UIButton *)setBtnWithBackgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleColor:(UIColor *)titleColor cornerRadius:(float)radius titleLabFont:(id)titleLabFont superView:(UIView *)superView;

+ (UILabel *)setLabWithText:(NSString *)text textColor:(UIColor *)textColor fontType:(id)fontdType;

+ (UIButton *)setBtnWithBackgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleColor:(UIColor *)titleColor cornerRadius:(float)radius titleLabFont:(id)titleLabFont;

+ (UITextField *)setTextFieldWithTintColor:(UIColor *)tintColor placeholder:(NSString *)placeholder placeholderTextColor:(UIColor *)placeholderTextColor placeholderTextFont:(int)placeholderTextFont textFieldTextFond:(id)font;

+ (ThemeButton *)setBlackThemeBtnWithTitle:(NSString *)title;

+ (ThemeButton *)setBorderThemeBtnWithTitle:(NSString *)title;


+ (UILabel *)labWithTitle:(NSString *)title titleColor:(UIColor *)color font:(id)fontdType;
+ (UIButton *)btnWithBackgroundNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage heighLightedImage:(UIImage *)heighLightedImage title:(NSString *)title titleColor:(UIColor *)color font:(id)fontType;

@end
