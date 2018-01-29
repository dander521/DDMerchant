//
//  DTOrderListTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderListTableViewCell.h"

@interface DTOrderListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *realMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paybackLabel;
@property (weak, nonatomic) IBOutlet UILabel *realMoneyDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *paybackDesLabel;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@end

@implementation DTOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(DTOrderListModel *)listModel {
    _listModel = listModel;
    
    DTOrderModel *orderModel = listModel.list.firstObject;
    
    [self.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:listModel.face]] placeholderImage:[UIImage imageNamed:@"user"]];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:orderModel.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    
    
    self.userNameLabel.text = listModel.name;
    self.orderNoLabel.text = [NSString stringWithFormat:@"单号：%@", listModel.orderNo];
    
    self.goodsName.text = listModel.list.count == 1 ? orderModel.name : [NSString stringWithFormat:@"%@等%zd商品", orderModel.name, listModel.list.count];
    self.goodsCountLabel.text = [NSString stringWithFormat:@"x%@", orderModel.num];
    self.payTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@", listModel.time];
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@", listModel.phone];
    if ([listModel.orderType isEqualToString:@"3"]) {
        self.remarkLabel.text = @"店铺买单";
        self.remarkLabel.textColor = RGB(246, 30, 46);
    } else {
        self.remarkLabel.text = [NSString stringWithFormat:@"备注：%@", listModel.remark];
    }
    self.realMoneyLabel.text = [NSString stringWithFormat:@"￥%@", listModel.orderPrice];
    self.paybackLabel.text = [NSString stringWithFormat:@"￥%@", listModel.sendPrice];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTOrderListTableViewCell";
    DTOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)setCellType:(DTOrderListTableViewCellType)cellType {
    _cellType = cellType;
    
    if (cellType == DTOrderListTableViewCellTypeNew) {
        self.paybackLabel.hidden = true;
        self.paybackDesLabel.hidden = true;
        self.realMoneyLabel.hidden = true;
        self.realMoneyDesLabel.hidden = true;
        [self.firstBtn setTitle:@"密码核销" forState:UIControlStateNormal];
        [self.secondBtn setTitle:@"扫码核销" forState:UIControlStateNormal];
    } else if (cellType == DTOrderListTableViewCellTypeOld) {
        self.paybackLabel.hidden = false;
        self.paybackDesLabel.hidden = false;
        self.realMoneyLabel.hidden = false;
        self.realMoneyDesLabel.hidden = false;
        [self.firstBtn removeFromSuperview];
        [self.secondBtn setTitle:@"申诉" forState:UIControlStateNormal];
    } else {
        [self.paybackLabel removeFromSuperview];
        [self.paybackDesLabel removeFromSuperview];
        [self.realMoneyLabel removeFromSuperview];
        [self.realMoneyDesLabel removeFromSuperview];
        [self.firstBtn removeFromSuperview];
        [self.secondBtn removeFromSuperview];
    }
}

- (IBAction)touchFirstBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchTicketVerifyButtonWithModel:)]) {
        [self.delegate touchTicketVerifyButtonWithModel:self.listModel];
    }
}

- (IBAction)touchSecondBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchActionButtonWithModel:)]) {
        [self.delegate touchActionButtonWithModel:self.listModel];
    }
}

@end
