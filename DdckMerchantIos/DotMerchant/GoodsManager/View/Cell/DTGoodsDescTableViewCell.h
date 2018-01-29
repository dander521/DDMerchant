//
//  DTGoodsDescTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2018/1/16.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGoodsInfoModel.h"

@protocol DTGoodsDescTableViewCellDelegate <NSObject>

- (void)inputGoodsDescriptionEndWithModel:(DTGoodsDesModel *)model row:(NSInteger)row;

@end

@interface DTGoodsDescTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, weak) id<DTGoodsDescTableViewCellDelegate> delegate;

@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, strong) DTGoodsDesModel *model;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
