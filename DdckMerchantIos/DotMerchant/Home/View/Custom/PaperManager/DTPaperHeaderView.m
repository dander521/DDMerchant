//
//  DTPaperHeaderView.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaperHeaderView.h"

@interface DTPaperHeaderView ()

@end

@implementation DTPaperHeaderView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    DTPaperHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    return customView;
}

@end
