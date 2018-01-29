//
//  DTStoreCategoryTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTStoreModel.h"

@protocol DTStoreCategoryTableViewCellDelegate <NSObject>

- (void)touchFirstOneButtonWithLabel:(UILabel *)label;

- (void)touchFirstTwoButtonWithLabel:(UILabel *)label;

- (void)touchSecondOneButtonWithLabel:(UILabel *)label;

- (void)touchSecondTwoButtonWithLabel:(UILabel *)label;

@end

@interface DTStoreCategoryTableViewCell : TXSeperateLineCell

@property (assign, nonatomic) id<DTStoreCategoryTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *firstOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTwoLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTwoLabel;

/** <#description#> */
@property (nonatomic, strong) NSArray *typeArray;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
