//
//  DTLoginTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTLoginTableViewCell.h"


@implementation DTLoginTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.registerBtn.layer.borderWidth = 1;
    self.registerBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    
    self.bgView.layer.shadowOffset = CGSizeMake(2, 2);
    self.bgView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    self.secondBgView.layer.cornerRadius = 10.0;
    self.secondBgView.layer.masksToBounds = true;
    self.bgView.layer.cornerRadius = 10.0;
    self.bgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTLoginTableViewCell";
    DTLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchLoginBnt:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchLoginButton)]) {
        [self.delegate touchLoginButton];
    }
}


- (IBAction)touchRetreiveBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchRetrieveButton)]) {
        [self.delegate touchRetrieveButton];
    }
}

- (IBAction)touchRegisterBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchRegisterButton)]) {
        [self.delegate touchRegisterButton];
    }
}










@end
