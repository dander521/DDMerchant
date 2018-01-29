//
//  DTPaperManagerTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaperManagerTableViewCell.h"

@interface DTPaperManagerTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation DTPaperManagerTableViewCell

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
    static NSString *cellID = @"DTPaperManagerTableViewCell";
    DTPaperManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)setCellType:(DTPaperManagerTableViewCellType)cellType {
    _cellType = cellType;
    if (cellType == DTPaperManagerTableViewCellTypeTitle) {
        self.avatarImageView.hidden = true;
        self.nameLabel.font = FONT(14);
        self.phoneLabel.font = FONT(14);
        self.rewardLabel.font = FONT(14);
        self.timeLabel.font = FONT(14);
        self.rewardLabel.textColor = RGB(46, 46, 46);
        self.phoneLabel.textColor = RGB(46, 46, 46);
        
        self.nameLabel.text = @"领取用户名";
        self.phoneLabel.text = @"电话号码";
        self.rewardLabel.text = @"提成";
        self.timeLabel.text = @"领取时间";
        
    } else {
        self.avatarImageView.hidden = false;
        self.nameLabel.font = FONT(12);
        self.phoneLabel.font = FONT(12);
        self.rewardLabel.font = FONT(12);
        self.timeLabel.font = FONT(12);
        self.rewardLabel.textColor = RGB(246, 30, 46);
        self.phoneLabel.textColor = RGB(153, 153, 153);
        self.timeLabel.textColor = RGB(153, 153, 153);
    }
}

- (void)setListModel:(DTPaperList *)listModel {
    _listModel = listModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:listModel.face]] placeholderImage:[UIImage imageNamed:@"user"]];
    
    self.nameLabel.text = listModel.userName;
    self.phoneLabel.text = listModel.phone;
    self.rewardLabel.text = listModel.deduct;
    self.timeLabel.text = [listModel.time substringToIndex:10];
}

@end
