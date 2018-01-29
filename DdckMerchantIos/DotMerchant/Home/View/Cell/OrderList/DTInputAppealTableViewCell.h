//
//  DTInputAppealTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTInputAppealTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
