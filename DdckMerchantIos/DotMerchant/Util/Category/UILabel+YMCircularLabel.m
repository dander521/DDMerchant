//
//  UILabel+YMCircularLabel.m
//  test
//
//  Created by liuyanming on 2017/3/30.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "UILabel+YMCircularLabel.h"

@implementation UILabel (YMCircularLabel)

- (void)circleLabel {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width*0.5];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

- (void)circleLabelWithWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
