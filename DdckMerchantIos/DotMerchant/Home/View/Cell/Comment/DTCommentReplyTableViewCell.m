//
//  DTCommentReplyTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2018/1/16.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import "DTCommentReplyTableViewCell.h"

@implementation DTCommentReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTCommentReplyTableViewCell";
    DTCommentReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)setReplyModel:(DTReplyModel *)replyModel {
    _replyModel = replyModel;
    NSString *replyStr = nil;
    if ([self.commentName isEqualToString:replyModel.name]) {
        replyStr = [NSString stringWithFormat:@"用户：%@", replyModel.content];
    } else {
        replyStr = [NSString stringWithFormat:@"回复：%@", replyModel.content];
    }
    self.replyLabel.text = replyStr;
}


@end
