//
//  TXGuideItemView.h
//  TailorX
//
//  Created by Qian Shen on 19/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXGuideItemView : UIView

/** title*/
@property (nonatomic, strong) UILabel *titleLabel;
/** subTitle*/
@property (nonatomic, strong) UILabel *subTitleLabel;
/** 引导页*/
@property (nonatomic, strong) UIImageView *coverImgView;
/** 用来变色的view*/
@property (nonatomic, strong) UIView *coverView;

@end
