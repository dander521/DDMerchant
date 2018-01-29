//
//  DTGoodsTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGoodsModel.h"
#import "DTCouponModel.h"

/**
 头部显示方式
 */
typedef NS_ENUM(NSUInteger, DTGoodsTableViewCellType) {
    DTGoodsTableViewCellTypeUp = 1, /**< 已上架 */
    DTGoodsTableViewCellTypeDown /**< 已下架 */
};

@protocol DTGoodsTableViewCellDelegate <NSObject>

- (void)touchDeleteButtonWithModel:(id)model;

- (void)touchEditButtonWithModel:(id)model;

- (void)touchActionButtonWithModel:(id)model;

@end

@interface DTGoodsTableViewCell : TXSeperateLineCell

@property (nonatomic, assign) DTGoodsTableViewCellType cellType;
@property (nonatomic, assign) id<DTGoodsTableViewCellDelegate>delegate;
/** <#description#> */
@property (nonatomic, strong) DTGoodsModel *goodsModel;
@property (nonatomic, strong) DTCouponModel *couponModel;
@property (nonatomic, assign) BOOL isGoods;
/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
