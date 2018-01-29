//
//  DTSaleStockTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSaleStockTableViewCell.h"

@interface DTSaleStockTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (weak, nonatomic) IBOutlet UIButton *saleStockBtn;

@end

@implementation DTSaleStockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomView.layer.shadowOffset = CGSizeMake(2, 2);
    self.bottomView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.bottomView.layer.shadowOpacity = 0.5;
    self.bottomView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touchSaleStockBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchSaleStockButton)]) {
        [self.delegate touchSaleStockButton];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTSaleStockTableViewCell";
    DTSaleStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end
