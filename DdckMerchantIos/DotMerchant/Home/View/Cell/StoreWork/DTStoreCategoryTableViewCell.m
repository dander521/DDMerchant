//
//  DTStoreCategoryTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTStoreCategoryTableViewCell.h"

@implementation DTStoreCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.firstOneLabel.layer.borderColor = RGB(153, 153, 153).CGColor;
    self.firstOneLabel.layer.borderWidth = 1;
    self.firstTwoLabel.layer.borderColor = RGB(153, 153, 153).CGColor;
    self.firstTwoLabel.layer.borderWidth = 1;
    self.secondOneLabel.layer.borderColor = RGB(153, 153, 153).CGColor;
    self.secondOneLabel.layer.borderWidth = 1;
    self.secondTwoLabel.layer.borderColor = RGB(153, 153, 153).CGColor;
    self.secondTwoLabel.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTypeArray:(NSArray *)typeArray {
    _typeArray = typeArray;
    
    if (!typeArray || typeArray.count == 0) {
        self.firstOneLabel.text = @"未选择分类";
        self.firstTwoLabel.text = @"未选择分类";
        self.secondOneLabel.text = @"未选择分类";
        self.secondTwoLabel.text = @"未选择分类";
    } else if (typeArray.count == 1) {
        DTStoreType *type = typeArray.firstObject;
        self.firstOneLabel.text = type.firstTypeName;
        self.firstTwoLabel.text = type.twoTypeName;
        self.secondOneLabel.text = @"未选择分类";
        self.secondTwoLabel.text = @"未选择分类";
    } else if (typeArray.count >= 2) {
        DTStoreType *type = typeArray.firstObject;
        self.firstOneLabel.text = type.firstTypeName;
        self.firstTwoLabel.text = type.twoTypeName;
        DTStoreType *type2 = typeArray.lastObject;
        self.secondOneLabel.text = type2.firstTypeName;
        self.secondTwoLabel.text = type2.twoTypeName;
    }
}

- (IBAction)touchFirstOneBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchFirstOneButtonWithLabel:)]) {
        [self.delegate touchFirstOneButtonWithLabel:self.firstOneLabel];
    }
}

- (IBAction)touchFirstTwoBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchFirstTwoButtonWithLabel:)]) {
        [self.delegate touchFirstTwoButtonWithLabel:self.firstTwoLabel];
    }
}

- (IBAction)touchSecondOneBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchSecondOneButtonWithLabel:)]) {
        [self.delegate touchSecondOneButtonWithLabel:self.secondOneLabel];
    }
}

- (IBAction)touchSecondTwoBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchSecondTwoButtonWithLabel:)]) {
        [self.delegate touchSecondTwoButtonWithLabel:self.secondTwoLabel];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTStoreCategoryTableViewCell";
    DTStoreCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
