//
//  DTCommentReplyTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2018/1/16.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCommentModel.h"

@interface DTCommentReplyTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (nonatomic, strong) DTReplyModel *replyModel;
@property (nonatomic, strong) NSString *commentName;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
