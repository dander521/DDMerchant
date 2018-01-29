//
//  DTGoodsTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsTableViewCell.h"

@interface DTGoodsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

@implementation DTGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    self.editBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoodsModel:(DTGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    self.goodNameLabel.text = goodsModel.name;
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [goodsModel.curPrice floatValue]];
    self.goodsDesLabel.text = goodsModel.title;
    NSArray *imgArray = [goodsModel.img componentsSeparatedByString:@","];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:imgArray.firstObject]] placeholderImage:[UIImage imageNamed:@"goods"]];
}

- (void)setCouponModel:(DTCouponModel *)couponModel {
    _couponModel = couponModel;
    
    self.goodNameLabel.text = @"代金券";
    self.goodsImageView.image = [UIImage imageNamed:@"Group"];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [couponModel.price floatValue]];
    self.goodsDesLabel.text = [NSString stringWithFormat:@"%@代%@，全场通用",couponModel.price, couponModel.usePrice];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTGoodsTableViewCell";
    DTGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (void)setCellType:(DTGoodsTableViewCellType)cellType {
    _cellType = cellType;
    
    if (cellType == DTGoodsTableViewCellTypeUp) {
        self.deleteBtn.hidden = true;
        [self.actionBtn setTitle:@"下架" forState:UIControlStateNormal];
    } else {
        self.deleteBtn.hidden = false;
        [self.actionBtn setTitle:@"上架" forState:UIControlStateNormal];
    }
}

- (IBAction)touchDeleteBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchDeleteButtonWithModel:)]) {
        if (self.isGoods) {
            [self.delegate touchDeleteButtonWithModel:self.goodsModel];
        } else {
            [self.delegate touchDeleteButtonWithModel:self.couponModel];
        }
    }
}

- (IBAction)touchEditBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchEditButtonWithModel:)]) {
        if (self.isGoods) {
            [self.delegate touchEditButtonWithModel:self.goodsModel];
        } else {
            [self.delegate touchEditButtonWithModel:self.couponModel];
        }
    }
}

- (IBAction)touchActionBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchActionButtonWithModel:)]) {
        if (self.isGoods) {
            [self.delegate touchActionButtonWithModel:self.goodsModel];
        } else {
            [self.delegate touchActionButtonWithModel:self.couponModel];
        }
    }
}






@end
