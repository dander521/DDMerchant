//
//  DTProfitTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2018/1/16.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTProfitTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *profitLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
