//
//  DTOrderListTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"

typedef NS_ENUM(NSInteger, DTOrderListTableViewCellType) {
    DTOrderListTableViewCellTypeNew = 1, /**< 新订单 */
    DTOrderListTableViewCellTypeOld, /**< 已处理、历史单 */
    DTOrderListTableViewCellTypeAppeal /**< 申诉 */
};

@protocol DTOrderListTableViewCellDelegate <NSObject>

- (void)touchTicketVerifyButtonWithModel:(DTOrderListModel *)model;

- (void)touchActionButtonWithModel:(DTOrderListModel *)model;

@end

@interface DTOrderListTableViewCell : TXSeperateLineCell

@property (assign, nonatomic) DTOrderListTableViewCellType cellType;
@property (assign, nonatomic) id<DTOrderListTableViewCellDelegate>delegate;

/** <#description#> */
@property (nonatomic, strong) DTOrderListModel *listModel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
