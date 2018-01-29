//
//  UITextView+TXPlaceholder.m
//  TailorX
//
//  Created by RogerChen on 23/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "UITextView+TXPlaceholder.h"

@implementation UITextView (TXPlaceholder)

/**
 设置textView placeholder
 
 @param text 文字
 @param textColor 颜色
 @param font 字体
 */
- (void)addPlaceholderWithText:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font {
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = text;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = textColor;
    [placeHolderLabel sizeToFit];
    
    // same font
    placeHolderLabel.font = font;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
        [self addSubview:placeHolderLabel];
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
}

@end
