//
//  UILabel+WYLabel.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/20.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UILabel+WYLabel.h"
#import "NSString+Extension.h"
#import "UIView+SFrame.h"

@implementation UILabel (WYLabel)

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    [superView addSubview:label];
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text superView:(UIView *)superView {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.text = text;
    [superView addSubview:label];
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text superView:(UIView *)superView frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.text = text;
    [superView addSubview:label];
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor superView:superView];
    label.textAlignment = alignment;
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment text:(NSString *)text {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor superView:superView alignment:Alignment];
    label.text = text;
    return label;
}

+ (UILabel *)labelWithframe:(CGRect)frame text:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.textAlignment = 1;
    label.textColor = textColor;
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment text:(NSString *)text frame:(CGRect)frame {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor superView:superView alignment:Alignment text:text];
    label.frame = frame;
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment backgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor superView:superView alignment:Alignment];
    label.backgroundColor = backgroundColor;
    return label;
}

/**
 * 根据标签的宽度来截取文字长度
 */
- (void)interceptingTextLengthAccordingToTheWidthOfTheLabelText:(NSString *)text {
    CGFloat labelWidth = self.width;
    NSLog(@"%@",self.font);
    CGFloat textWidth = [self heightForString:text fontSize:self.font andWidth:SCREEN_WIDTH].width;
    while (textWidth > labelWidth) {
        NSString *tempStr;
        if (self.text.length > 1) {
              tempStr = [text substringToIndex:self.text.length - 1];
        }
        if (![NSString isTextEmpty:tempStr]) {
            textWidth =  [self heightForString:text fontSize:self.font andWidth:labelWidth].width;
        }
        self.text = tempStr;
    }
}

/**
 * 计算文字的宽高
 */
- (CGSize)heightForString:(NSString *)value fontSize:(UIFont*)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = fontSize;
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

@end
