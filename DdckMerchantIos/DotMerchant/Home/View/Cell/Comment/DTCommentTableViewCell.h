//
//  DTCommentTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCommentModel.h"

@class DTCommentTableViewCell;

@protocol DTCommentTableViewCellDelegate <NSObject>

- (void)touchImageViewWithIndex:(NSInteger)index array:(NSArray *)imgArray cell:(DTCommentTableViewCell *)cell;

- (void)touchReplyButtonWithModel:(DTCommentModel *)model;

@end

@interface DTCommentTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UIImageView *firstCommentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondCommentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdCommentImageView;

/** <#description#> */
@property (nonatomic, assign) BOOL isDetail;
@property (assign, nonatomic) id <DTCommentTableViewCellDelegate> delegate;
/** <#description#> */
@property (nonatomic, strong) DTCommentModel *commentModel;
/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
