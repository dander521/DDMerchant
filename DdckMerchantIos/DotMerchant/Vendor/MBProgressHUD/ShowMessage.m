//
//  ShowMessage.m
//  LoginDemo
//
//  Created by   徐安超 on 16/6/16.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "ShowMessage.h"

@implementation ShowMessage

static int showViewHeight=30;
+(void)showMessage:(NSString*)message;{
    CGPoint point = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [ShowMessage showMessage:message withCenter:point];
    
}

+(void)showMessage:(NSString *)message withCenter:(CGPoint)center{
    
#pragma mark -创建提示框
    
    NSString * messageContent = message;
    
    if ([message isEqualToString:@""]) {
        return;
    }
    
    if (message == nil || message.length > 40) {
        messageContent = @"服务器繁忙，请稍后重试";
    }
    
    [UIView animateWithDuration:3.0 delay:1.0f options:2 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UIView *showView = [[UIView alloc] init];
        showView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        showView.alpha = 1.0f;
        showView.layer.cornerRadius = 5.0f;
        showView.layer.masksToBounds = YES;
        [window addSubview:showView];
        
#pragma mark -文字显示
        UILabel *textLabel = [[UILabel alloc] init];
        CGSize Labelsize = [messageContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} context:nil].size;
        textLabel.text = messageContent;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        textLabel.frame = CGRectMake(10, (showViewHeight-5)/2, Labelsize.width, Labelsize.height);
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:13];
        [showView addSubview:textLabel];
        
#pragma mark -提示框的位置
        showView.frame = CGRectMake((SCREEN_WIDTH-Labelsize.width-20)/2, SCREEN_HEIGHT-120, Labelsize.width+showViewHeight-10, Labelsize.height+showViewHeight-5);
        //        if(center.x){
        //             showView.center=center;
        //        }
        showView.center = center;
        
        //设置动画隐藏提示框
        [UIView animateWithDuration:3 animations:^{
            showView.alpha = 0;
        } completion:^(BOOL finished) {
            [showView removeFromSuperview];
        }];
        
        
    }];
    
    
}
+(void)showMessage:(NSString *)message size:(NSString *)sizeter{
#pragma mark -创建提示框
    
    
    
    [UIView animateWithDuration:2.0 delay:1.0f options:2 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UIView *showView = [[UIView alloc] init];
        showView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];;
        showView.alpha = 1;
        showView.layer.cornerRadius = 5.0f;
        showView.layer.masksToBounds = YES;
        [window addSubview:showView];
        [showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(window.mas_centerX);
            make.centerY.equalTo(window.mas_centerY);
            make.width.equalTo(@(100));
            make.height.equalTo(@(100));
        }];
#pragma mark -图片显示
        UILabel *imgLabel=[[UILabel alloc]init];
        imgLabel.font =[UIFont fontWithName:@"iconfont" size:40];
        imgLabel.textColor=[UIColor whiteColor];
        imgLabel.text =@"\U0000e608";
        imgLabel.backgroundColor=[UIColor clearColor];
        [showView addSubview:imgLabel];
        imgLabel.frame=CGRectMake(30, 10, 40, 40);
        //        [imgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //            make.top.equalTo(showView.mas_top).mas_offset(10);
        //        }];
#pragma mark -文字显示
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = message;
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:13];
        [showView addSubview:textLabel];
        textLabel.frame =CGRectMake(25, 65, 70, 20);
        //        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.bottom.equalTo(showView.mas_bottom).mas_offset(-10);
        //            make.centerX.equalTo(imgLabel.mas_centerX);
        //        }];
        
#pragma mark -提示框的位置
        //        showView.frame = CGRectMake(0, SCREEN_HEIGHT-60, 20, 10);
        
        //设置动画隐藏提示框
        [UIView animateWithDuration:2 animations:^{
            showView.alpha = 0;
        } completion:^(BOOL finished) {
            [showView removeFromSuperview];
        }];
    }];
}




@end
