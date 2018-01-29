//
//  DTPaperManagerTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTPaperListModel.h"

typedef NS_ENUM(NSInteger, DTPaperManagerTableViewCellType) {
    DTPaperManagerTableViewCellTypeTitle = 0,
    DTPaperManagerTableViewCellTypeContent
};

@interface DTPaperManagerTableViewCell : TXSeperateLineCell

@property (nonatomic, assign) DTPaperManagerTableViewCellType cellType;
/** <#description#> */
@property (nonatomic, strong) DTPaperList *listModel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
