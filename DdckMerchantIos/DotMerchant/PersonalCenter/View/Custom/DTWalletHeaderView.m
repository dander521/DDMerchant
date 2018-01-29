//
//  DTWalletHeaderView.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTWalletHeaderView.h"

@implementation DTWalletHeaderView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    DTWalletHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    return customView;
}

@end
