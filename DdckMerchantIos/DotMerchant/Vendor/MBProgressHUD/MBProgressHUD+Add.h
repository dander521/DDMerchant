//
//  MBProgressHUD+Add.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showMBError:(NSString *)error toView:(UIView *)view;
+ (void)showMBSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMBMessag:(NSString *)message toView:(UIView *)view;
@end
