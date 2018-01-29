//
//  UILabel+YMCircularLabel.h
//  test
//
//  Created by liuyanming on 2017/3/30.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (YMCircularLabel)

- (void)circleLabel;

- (void)circleLabelWithWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;

@end
