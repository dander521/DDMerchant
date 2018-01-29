//
//  TailorxFactory.m
//  Tailorx
//
//  Created by 高习泰 on 16/7/29.
//  Copyright © 2016年   高习泰. All rights reserved.
//

#import "TailorxFactory.h"

@implementation TailorxFactory
+ (UILabel *)setLabWithText:(NSString *)text textColor:(UIColor *)textColor fontType:(UIFont *)fontdType superView:(UIView *)superView {
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = fontdType;
    label.adjustsFontSizeToFitWidth = YES;
    [superView addSubview:label];
    return label;
}


+ (UIButton *)setBtnWithBackgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleColor:(UIColor *)titleColor cornerRadius:(float)radius titleLabFont:(id)titleLabFont superView:(UIView *)superView {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:backgroundColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = titleLabFont;
    [superView addSubview:btn];
    return btn;
}


+ (UILabel *)setLabWithText:(NSString *)text textColor:(UIColor *)textColor fontType:(id)fontdType {
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = fontdType;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}



+ (UIButton *)setBtnWithBackgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleColor:(UIColor *)titleColor cornerRadius:(float)radius titleLabFont:(id)titleLabFont {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:backgroundColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = titleLabFont;
    return btn;
}


+ (UITextField *)setTextFieldWithTintColor:(UIColor *)tintColor placeholder:(NSString *)placeholder placeholderTextColor:(UIColor *)placeholderTextColor placeholderTextFont:(int)placeholderTextFont textFieldTextFond:(id)font {
    UITextField *textField = [[UITextField alloc] init];
    textField.tintColor = tintColor;
    textField.placeholder = placeholder;
    [textField setValue:placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont boldSystemFontOfSize:placeholderTextFont] forKeyPath:@"_placeholderLabel.font"];
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = font;
    return textField;
}

+ (ThemeButton *)setBlackThemeBtnWithTitle:(NSString *)title {
    ThemeButton * btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.cloNameN = @"theme_Btn_bg_color";
    btn.cloNameH = @"theme_Btn_bg_color";
    btn.titleCloNameN = @"theme_Btn_title_color";
    btn.titleCloNameH = @"theme_Btn_title_color";
//    btn.layer.cornerRadius = 3;
//    btn.layer.masksToBounds = YES;
    return btn;
}

+ (ThemeButton *)setBorderThemeBtnWithTitle:(NSString *)title {
    ThemeButton * btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    
//    UIColor *color = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_Btn_bg_color"];
    
    btn.cloNameN = @"clear_color";
    btn.cloNameH = @"clear_color";
    
    btn.titleCloNameN = @"theme_Btn_bg_color";
    btn.titleCloNameH = @"theme_Btn_bg_color";
    
    btn.borderColor = @"theme_Btn_bg_color";
//    btn.layer.borderColor = color.CGColor;
    btn.layer.borderWidth = 0.5;
    
    return btn;
}

+ (UILabel *)labWithTitle:(NSString *)title titleColor:(UIColor *)color font:(id)fontdType {
        UILabel * lab = [[UILabel alloc] init];
        lab.text = title;
        lab.textColor = color;
        lab.font = fontdType;
        [lab sizeToFit];
        return lab;
}

+ (UIButton *)btnWithBackgroundNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage heighLightedImage:(UIImage *)heighLightedImage title:(NSString *)title titleColor:(UIColor *)color font:(id)fontType {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normalImage != nil) {
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    }
    if (selectedImage != nil) {
        [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
    }
    if (heighLightedImage != nil) {
        [btn setBackgroundImage:heighLightedImage forState:UIControlStateHighlighted];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = fontType;
    return btn;
}

@end
