//
//  TXCustomTools.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCustomTools.h"
#import "NSString+Extension.h"

@implementation TXCustomTools

/**
 调起系统拨打电话
 
 @param phoneNo 电话号码
 */
+ (void)callStoreWithPhoneNo:(NSString *)phoneNo target:(UIViewController *)target {
    if ([NSString isTextEmpty:phoneNo]) {
        [ShowMessage showMessage:@"该门店没有留下电话哦！" withCenter:CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0)];
    }else {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"联系平台" style:UIAlertActionStyleDefault handler:nil];
        [TXCustomTools setActionTitleTextColor:RGB(26, 26, 26) action:callAction];
        callAction.enabled = NO;
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:phoneNo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@", phoneNo];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVc dismissViewControllerAnimated:true completion:nil];
        }];

        [alertVc addAction:callAction];
        [alertVc addAction:noAction];
        [alertVc addAction:cancelAction];
        
        [target presentViewController:alertVc animated:true completion:nil];
    }
}

/**
 设置alert按钮颜色
 
 @param color
 @param action
 */
+ (void)setActionTitleTextColor:(UIColor *)color action:(UIAlertAction *)action {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
        [action setValue:color forKey:@"titleTextColor"];
    }
}

+ (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
