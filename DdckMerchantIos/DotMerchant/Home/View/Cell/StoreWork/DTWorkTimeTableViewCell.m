//
//  DTWorkTimeTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTWorkTimeTableViewCell.h"

@implementation DTWorkTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)touchFromBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchFromButtonWithButton:)]) {
        [self.delegate touchFromButtonWithButton:sender];
    }
}

- (IBAction)touchToBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchToButtonWithButton:)]) {
        [self.delegate touchToButtonWithButton:sender];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTWorkTimeTableViewCell";
    DTWorkTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
