//
//  DTPaperHeaderView.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTPaperHeaderView : UIView


@property (weak, nonatomic) IBOutlet UILabel *paperTodayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastPaperLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end
