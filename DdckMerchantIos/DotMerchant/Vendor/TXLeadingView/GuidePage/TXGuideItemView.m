//
//  TXGuideItemView.m
//  TailorX
//
//  Created by Qian Shen on 19/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXGuideItemView.h"
#import "UILabel+WYLabel.h"
#import "UIImage+YMImg.h"
#import "UIImageView+WYImageView.h"

@implementation TXGuideItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    // title
    self.titleLabel = [UILabel labelWithFont:24.0
                                   textColor:RGB(48, 58, 56)
                                        text:@"中华人民共和国"
                                   superView:self];
    
    // subTitle
    self.subTitleLabel = [UILabel labelWithFont:15.0
                                      textColor:RGB(146, 146, 146)
                                           text:@"中华人民共和国" superView:self];
    
    // imageV
    self.coverImgView = [UIImageView imageViewWithImageName:@""
                                                  superView:self];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(LayoutH(57.5));
        make.height.mas_equalTo(@(28));
    }];

    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(LayoutH(10));
        make.height.mas_equalTo(@(28));
    }];
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-LayoutH(23));
        make.left.equalTo(self).offset(LayoutW(23));
        make.right.equalTo(self).offset(-LayoutW(23));
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(LayoutH(40));
    }];
    if (SCREEN_WIDTH == 320) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self).offset(20);
        }];
        [self.coverImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
        }];
    }
}

@end
