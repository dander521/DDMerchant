//
//  TXCountDownTime.h
//  TailorX
//
//  Created by Qian Shen on 23/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TXCountDownTime : NSObject

/**
 开启倒计时
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color atBtn:(UIButton *)btn;
/**
 停止倒计时
 */
- (void)stopCountDownTimeAtBtn:(UIButton *)btn;

singleton_interface(TXCountDownTime)

@end
