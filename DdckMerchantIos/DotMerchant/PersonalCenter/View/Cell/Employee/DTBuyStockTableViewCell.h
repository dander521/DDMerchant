//
//  DTBuyStockTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTBuyStockTableViewCellDelegate <NSObject>

- (void)touchBuyStockButton;

- (void)touchRulesButton;

@end

@interface DTBuyStockTableViewCell : TXSeperateLineCell

@property (nonatomic, assign) id<DTBuyStockTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *buyStockLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
