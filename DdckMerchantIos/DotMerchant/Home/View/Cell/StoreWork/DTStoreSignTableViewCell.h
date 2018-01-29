//
//  DTStoreSignTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTStoreSignTableViewCellDelegate <NSObject>

- (void)touchAddSignButton;

@end

@interface DTStoreSignTableViewCell : TXSeperateLineCell

@property (assign, nonatomic) id <DTStoreSignTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *addSignBtn;
@property (weak, nonatomic) IBOutlet UILabel *addSignLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
