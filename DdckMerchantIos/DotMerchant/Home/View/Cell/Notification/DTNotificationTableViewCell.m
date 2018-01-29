//
//  DTNotificationTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTNotificationTableViewCell.h"

@interface DTNotificationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
@property (weak, nonatomic) IBOutlet UILabel *goodsPayTimeLabel;


@end

@implementation DTNotificationTableViewCell

- (void)setNotificationModel:(DTNotificationModel *)notificationModel {
    _notificationModel = notificationModel;
    DTNotificationSubModel *subModel = notificationModel.list.firstObject;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:subModel.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.goodsPayTimeLabel.text = notificationModel.time;
    self.statusLabel.text = notificationModel.title;
    self.noticeLabel.text = notificationModel.orderTime;
    if ([notificationModel.type isEqualToString:@"1"]) {
        self.goodsCount.hidden = true;
        self.goodsName.text = notificationModel.content;
    } else {
        self.goodsName.text = notificationModel.list.count == 1 ? subModel.name : [NSString stringWithFormat:@"%@等%zd件商品", subModel.name, notificationModel.list.count];
        self.goodsCount.text = [NSString stringWithFormat:@"x%zd", [subModel.num integerValue]];
        
        if ([notificationModel.orderStatus integerValue] == 2) {
            self.statusImageView.backgroundColor = RGB(153, 153, 153);
        } else {
            self.statusImageView.backgroundColor = RGB(247, 30, 46);
        }
    }
}


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
    static NSString *cellID = @"DTNotificationTableViewCell";
    DTNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}


@end
