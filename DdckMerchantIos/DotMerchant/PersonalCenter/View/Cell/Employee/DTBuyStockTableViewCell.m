//
//  DTBuyStockTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTBuyStockTableViewCell.h"

@interface DTBuyStockTableViewCell ()


@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation DTBuyStockTableViewCell

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

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTBuyStockTableViewCell";
    DTBuyStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (IBAction)touchBuyStockBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchBuyStockButton)]) {
        [self.delegate touchBuyStockButton];
    }
}
- (IBAction)touchEmployeeRules:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchRulesButton)]) {
        [self.delegate touchRulesButton];
    }
}

@end
