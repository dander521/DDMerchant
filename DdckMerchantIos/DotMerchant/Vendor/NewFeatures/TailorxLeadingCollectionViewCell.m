//
//  TailorxLeadingCollectionViewCell.m
//  Tailorx
//
//  Created by 高习泰 on 16/8/24.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "TailorxLeadingCollectionViewCell.h"

@implementation TailorxLeadingCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.leadingImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.leadingImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.leadingImageView];

        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = self.contentView.bounds;
        [self.contentView addSubview:touchBtn];
        
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btn];
        _btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [_btn setTitle:@"立即体验" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        if (SCREEN_WIDTH > 320) {
            [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(-10);
                make.bottom.mas_equalTo(-80);
                make.size.mas_equalTo(CGSizeMake(130, 40));
            }];
        } else {
            [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(-10);
                make.bottom.mas_equalTo(-60);
                make.size.mas_equalTo(CGSizeMake(130, 40));
            }];
        }
  
        _animationImgView = [[UIImageView alloc]init];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 3; i++) {
            NSString *str;
            str = [NSString stringWithFormat:@"arrow_0%d", i];
            UIImage *image = [UIImage imageNamed:str];
            [arr addObject:image];
        }
        _animationImgView.animationImages = arr;
        self.userInteractionEnabled = YES;
        [_animationImgView setAnimationDuration:1.1];
        [_animationImgView setAnimationRepeatCount:0];
//        [_animationImgView startAnimating];
        [_btn addSubview:_animationImgView];
        [_animationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_btn.mas_right);
            make.centerY.equalTo(_btn);
        }];
        
    }
    return self;
}
@end
