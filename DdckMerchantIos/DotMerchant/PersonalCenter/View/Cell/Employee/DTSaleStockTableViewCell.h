//
//  DTSaleStockTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTSaleStockTableViewCellDelegate <NSObject>

- (void)touchSaleStockButton;

@end

@interface DTSaleStockTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *myStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *originStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowStockLabel;
@property (nonatomic, assign) id<DTSaleStockTableViewCellDelegate>delegate;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
