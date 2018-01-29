//
//  TXLeadingView.m
//  TailorX
//
//  Created by 程荣刚 on 2017/6/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXLeadingView.h"

@implementation TXLeadingView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

@end
