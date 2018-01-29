//
//  DTEditGoodsTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTEditGoodsTableViewCell.h"

@interface DTEditGoodsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;


@end

@implementation DTEditGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsStoreType:(BOOL)isStoreType {
    _isStoreType = isStoreType;
    self.categoryBtn.hidden = isStoreType;
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTEditGoodsTableViewCell";
    DTEditGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (IBAction)touchSelecteBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchSelecteButtonWithLabel:storeType:)]) {
        [self.delegate touchSelecteButtonWithLabel:self.categoryLabel storeType:self.isStoreType];
    }
}

- (IBAction)touchCategoryBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchCategoryButton)]) {
        [self.delegate touchCategoryButton];
    }
}

@end
