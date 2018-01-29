//
//  TXCountDownTime.m
//  TailorX
//
//  Created by Qian Shen on 23/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCountDownTime.h"

@interface TXCountDownTime ()

/** 倒计时时间*/
@property (nonatomic, assign) NSInteger timeOut;

@property (nonatomic, strong) dispatch_source_t timer;


@end

@implementation TXCountDownTime

singleton_implementation(TXCountDownTime)


- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color atBtn:(UIButton*)btn {
    
    //倒计时时间
    self.timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (self.timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                btn.backgroundColor = mColor;
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = self.timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                btn.backgroundColor = color;
                [btn setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                [btn setTitleColor:RGB(204, 204, 204) forState:UIControlStateNormal];
            });
            self.timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)stopCountDownTimeAtBtn:(UIButton*)btn {
    NSLog(@"%@",_timer);
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
        
        [btn setTitle:@"获取验证码"forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    });
}

@end
