//
//  UITextView+TXPlaceholder.h
//  TailorX
//
//  Created by RogerChen on 23/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TXPlaceholder)

/**
 设置textView placeholder

 @param text 文字
 @param textColor 颜色
 @param font 字体
 */
- (void)addPlaceholderWithText:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font;

@end
