//
//  DTNotificationTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTNotificationModel.h"

@interface DTNotificationTableViewCell : TXSeperateLineCell

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** <#description#> */
@property (nonatomic, strong) DTNotificationModel *notificationModel;

@end
