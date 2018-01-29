//
//  TXUploadPictureCollCell.m
//  TailorX
//
//  Created by Qian Shen on 20/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXUploadPictureCollCell.h"

@implementation TXUploadPictureCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

// 删除按钮的点击事件

- (IBAction)clickDeleteBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadPictureCollCell:didSelectItemOfIndex:)]) {
        [self.delegate uploadPictureCollCell:self didSelectItemOfIndex:self.index];
    }
}

@end
