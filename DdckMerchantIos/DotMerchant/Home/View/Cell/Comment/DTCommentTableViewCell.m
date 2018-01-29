//
//  DTCommentTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCommentTableViewCell.h"
#import "XHStarRateView.h"

@interface DTCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;


@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@property (weak, nonatomic) IBOutlet UIView *starBgView;

@property (strong, nonatomic) XHStarRateView *starView;

/** <#description#> */
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation DTCommentTableViewCell

- (void)setCommentModel:(DTCommentModel *)commentModel {
    _commentModel = commentModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:commentModel.face]] placeholderImage:[UIImage imageNamed:@"user"]];
    self.nameLabel.text = commentModel.name;
    self.dateLabel.text = commentModel.time;
    self.commentLabel.text = commentModel.content;
    DTReplyModel *replay = commentModel.replyList.lastObject;
    NSString *replyStr = [NSString isTextEmpty:replay.content] ? @"回复：暂无" : [NSString stringWithFormat:@"回复：%@", replay.content];
    self.replyLabel.text = replyStr;
    self.replyLabel.hidden = self.isDetail;

    self.starView.currentScore = [commentModel.score floatValue];
    
    if ([NSString isTextEmpty:commentModel.img]) {
        [self.firstCommentImageView removeFromSuperview];
        [self.secondCommentImageView removeFromSuperview];
        [self.thirdCommentImageView removeFromSuperview];
    }
    
    if (![NSString isTextEmpty:commentModel.img]) {
        NSArray *photoArray = [commentModel.img componentsSeparatedByString:@","];
        
        self.commentArray = [NSMutableArray new];
        if (photoArray.count > 3) {
            for (int i = 0; i < 3; i++) {
                [self.commentArray addObject:photoArray[i]];
            }
        } else {
            [self.commentArray addObjectsFromArray:photoArray];
        }
        
        if (self.commentArray.count == 1) {
            self.firstCommentImageView.hidden = false;
            self.secondCommentImageView.hidden = true;
            self.thirdCommentImageView.hidden = true;
        } else if (self.commentArray.count == 2) {
            self.firstCommentImageView.hidden = false;
            self.secondCommentImageView.hidden = false;
            self.thirdCommentImageView.hidden = true;
        } else if (self.commentArray.count == 3) {
            self.firstCommentImageView.hidden = false;
            self.secondCommentImageView.hidden = false;
            self.thirdCommentImageView.hidden = false;
        } else {
            self.firstCommentImageView.hidden = false;
            self.secondCommentImageView.hidden = true;
            self.thirdCommentImageView.hidden = true;
        }
        
        for (int i = 0; i < self.commentArray.count; i++) {
            if (i == 0) {
                [self.firstCommentImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:self.commentArray[i]]] placeholderImage:[UIImage imageNamed:@"goods"]];
            } else if (i == 1) {
                [self.secondCommentImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:self.commentArray[i]]] placeholderImage:[UIImage imageNamed:@"goods"]];
            } else if (i == 2) {
                [self.thirdCommentImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:self.commentArray[i]]] placeholderImage:[UIImage imageNamed:@"goods"]];
            }
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.currentScore = 5;
    self.starView.userInteractionEnabled = NO;
    [self.starBgView addSubview:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touchReplyBtn:(id)sender {
    NSLog(@"touchReplyBtn");
    if ([self.delegate respondsToSelector:@selector(touchReplyButtonWithModel:)]) {
        [self.delegate touchReplyButtonWithModel:self.commentModel];
    }
}

- (IBAction)tapImageView:(UITapGestureRecognizer *)sender {
    NSLog(@"tag = %zd", sender.view.tag);
    if ([self.delegate respondsToSelector:@selector(touchImageViewWithIndex:array:cell:)]) {
        [self.delegate touchImageViewWithIndex:sender.view.tag-1 array:self.commentArray cell:self];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTCommentTableViewCell";
    DTCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
