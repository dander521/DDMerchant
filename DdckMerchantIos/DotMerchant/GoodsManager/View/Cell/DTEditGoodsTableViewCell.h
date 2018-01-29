//
//  DTEditGoodsTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTEditGoodsTableViewCellDelegate <NSObject>

- (void)touchSelecteButtonWithLabel:(UILabel *)label storeType:(BOOL)storeType;

- (void)touchCategoryButton;

@end

@interface DTEditGoodsTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (assign, nonatomic) id<DTEditGoodsTableViewCellDelegate>delegate;
// 是否为入驻分类
@property (nonatomic, assign) BOOL isStoreType;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
