//
//  DTWorkTimeTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTWorkTimeTableViewCellDelegate <NSObject>

- (void)touchFromButtonWithButton:(UIButton *)btn;

- (void)touchToButtonWithButton:(UIButton *)btn;

@end

@interface DTWorkTimeTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UIButton *fromBtn;
@property (weak, nonatomic) IBOutlet UIButton *toBtn;

@property (assign, nonatomic) id<DTWorkTimeTableViewCellDelegate>delegate;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
