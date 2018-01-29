//
//  DTGoodsDescTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2018/1/16.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import "DTGoodsDescTableViewCell.h"

@interface DTGoodsDescTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *secondTF;
@property (weak, nonatomic) IBOutlet UITextField *thirdTF;



@end

@implementation DTGoodsDescTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstTF.delegate = self;
    self.secondTF.delegate = self;
    self.thirdTF.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.model = [DTGoodsDesModel new];
    self.model.firstParam = @"";
    self.model.twoParam = @"";
    self.model.threeParam = @"";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)textFieldDidChange:(NSNotification *)noti {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:true];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.firstTF) {
        self.model.firstParam = [NSString isTextEmpty:self.firstTF.text] ? @"" : self.firstTF.text;
    } else if (textField == self.secondTF) {
        self.model.twoParam = [NSString isTextEmpty:self.secondTF.text] ? @"" : self.secondTF.text;
    } else if (textField == self.thirdTF) {
        self.model.threeParam = [NSString isTextEmpty:self.thirdTF.text] ? @"" : self.thirdTF.text;
    }
    
    if ([self.delegate respondsToSelector:@selector(inputGoodsDescriptionEndWithModel:row:)]) {
        [self.delegate inputGoodsDescriptionEndWithModel:self.model row:self.indexRow];
    }
}

- (void)setModel:(DTGoodsDesModel *)model {
    _model = model;

    self.firstTF.text = model.firstParam;
    self.secondTF.text = model.twoParam;
    self.thirdTF.text = model.threeParam;
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTGoodsDescTableViewCell";
    DTGoodsDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}



@end
