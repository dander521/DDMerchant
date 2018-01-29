//
//  TXBlankView.m
//  TailorX
//
//  Created by 温强 on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBlankView.h"
#import "ThemeButton.h"
#import "TailorxFactory.h"

@interface TXBlankView()


    
@end
@implementation TXBlankView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/**
 带 图片/单行提示语 的空白页
 
 @param image 图片名
 @param title 主提示语
 
 */
- (void)createBlankViewWithImage:(NSString *)image title:(NSString *)title {
    
    [self createBlankViewWithImage:image
                             title:title
                          subTitle:nil];
}

/**
 带 图片/单行提示语/底部按钮 的空白页
 
 @param image 图片名
 @param title 主提示语
 @param buttonTitle 底部按钮title
 */
- (void)createBlankViewWithImage:(NSString *)image
                           title:(NSString *)title
                     buttonTitle:(NSString *)buttonTitle {
    
    [self createBlankViewWithImage:image
                             title:title
                          subTitle:nil
                       buttonTitle:buttonTitle];
    
}

/**
 带 图片/两行提示语 的空白页
 
 @param image 图片名
 @param title 主提示语
 @param subTitle 副提示语
 
 */
- (void)createBlankViewWithImage:(NSString *)image
                           title:(NSString *)title
                        subTitle:(NSString *)subTitle {
    
    [self createBlankViewWithImage:image
                             title:title
                          subTitle:subTitle
                       buttonTitle:nil];
    
}

/**
 带 图片/两行提示语/底部按钮 的空白页
 
 @param image 图片名
 @param title 主提示语
 @param subTitle 副提示语
 @param buttonTitle 底部按钮title
 */
- (void)createBlankViewWithImage:(NSString *)image
                           title:(NSString *)title
                        subTitle:(NSString *)subTitle
                     buttonTitle:(NSString *)buttonTitle {
    
    // 图片
//    UIImageView *contentImageView = [UIImageView imageViewWithImageName:image
//                                                                  frame:CGRectZero
//                                                              superView:self];
    
    UIImage *img = [UIImage imageNamed:image];
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    contentImageView.image = img;
    [self addSubview:contentImageView];
    self.imgView = contentImageView;
    
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(LayoutH(LayoutH(60) + 60));
        make.centerX.equalTo(self);
    }];
    
    // title
    UILabel *titleLab = [UILabel labelWithFont:15.0
                                     textColor:RGB(29, 29, 38)
                                     superView:self];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(contentImageView.mas_bottom).offset(LayoutH(50.0));
    }];
    
    // subtitle
    if (subTitle.length > 0) {
        UILabel *subTitleLab = [UILabel labelWithFont:14.0
                                            textColor:RGB(153.0, 153.0, 153.0)
                                            superView:self];
        subTitleLab.textAlignment = NSTextAlignmentCenter;
        subTitleLab.text = subTitle;
        subTitleLab.numberOfLines = 0;
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(titleLab.mas_bottom).offset(LayoutH(10.0));;
        }];
        
    };
    // 底部button
    if (buttonTitle.length > 0) {

     ThemeButton *bottomBtn = [TailorxFactory setBlackThemeBtnWithTitle:buttonTitle];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [bottomBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomBtn];
        
        [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(LayoutH(50));
        }];
    }
}

/**
 带 图片/两行提示语/两底部按钮 的空白页
 
 @param image 图片名
 @param title 主提示语
 @param subTitle 副提示语
 @param buttonTitle 底部按钮title
 */
- (void)createBlankViewWithImage:(NSString *)image
                           title:(NSString *)title
                        subTitle:(NSString *)subTitle
                     buttonTitle:(NSString *)buttonTitle
                     buttonTitle:(NSString *)secondButtonTitle {
    // 图片
    
//    UIImageView *contentImageView = [UIImageView imageViewWithImageName:image
//                                                                  frame:CGRectZero
//                                                              superView:self];
    UIImage *img = [UIImage imageNamed:image];
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    contentImageView.image = img;
    [self addSubview:contentImageView];
    self.imgView = contentImageView;
    
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(LayoutH(60));
        make.centerX.equalTo(self);
    }];
    
    // title
    UILabel *titleLab = [UILabel labelWithFont:15.0
                                     textColor:RGB(29, 29, 38)
                                     superView:self];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(contentImageView.mas_bottom).offset(LayoutH(50.0));
    }];
    
    // subtitle
    if (subTitle.length > 0) {
        UILabel *subTitleLab = [UILabel labelWithFont:14.0
                                            textColor:RGB(153.0, 153.0, 153.0)
                                            superView:self];
        subTitleLab.textAlignment = NSTextAlignmentCenter;
        subTitleLab.text = subTitle;
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(titleLab.mas_bottom).offset(LayoutH(10.0));;
        }];
        
    };
    // 底部button
    UIButton *firstBtn = nil;
    if (buttonTitle.length > 0) {
        firstBtn = [UIButton buttonWithTitle:buttonTitle
                                   textColor:[UIColor blackColor]
                                        font:17.0
                                      action:@selector(bottomBtnClicked:)
                                       frame:CGRectZero
                                      source:self
                                   superView:self];
//        firstBtn = [TailorxFactory setBlackThemeBtnWithTitle:buttonTitle];
        firstBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [firstBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:firstBtn];
        firstBtn.tag = FirstButtonTag;

        [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.height.mas_equalTo(LayoutH(50));
        }];
    }
    
    // 底部button
    ThemeButton *secondBtn = nil;
    if (secondButtonTitle.length > 0) {
//        secondBtn = [UIButton buttonWithTitle:secondButtonTitle
//                                    textColor:[UIColor whiteColor]
//                                         font:17.0
//                                       action:@selector(bottomBtnClicked:)
//                                        frame:CGRectZero
//                                       source:self
//                                    superView:self];
        
        secondBtn = [TailorxFactory setBlackThemeBtnWithTitle:secondButtonTitle];
        secondBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [secondBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:secondBtn];
        secondBtn.tag = SecondButtonTag;
      
        
        [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self);
            make.width.equalTo(firstBtn);
            make.left.equalTo(firstBtn.mas_right);
            make.height.mas_equalTo(LayoutH(50));
        }];
    }
}


- (void)showBlankViewWithImage:(NSString *)image title:(NSString *)title subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle {
    
    self.backgroundColor = [UIColor whiteColor];
    // 图片
    UIImage *img = [UIImage imageNamed:image];
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    contentImageView.image = img;
    [self addSubview:contentImageView];
    self.imgView = contentImageView;
    
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewTapClick)]];
    
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(LayoutH(40));
        make.centerX.equalTo(self);
        // make.size.mas_equalTo(CGSizeMake(LayoutW(150), LayoutH(140)));
    }];
    
    // title
    UILabel *titleLab = [UILabel labelWithFont:15.0
                                     textColor:RGB(29, 29, 38)
                                     superView:self];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(contentImageView.mas_bottom).offset(LayoutH(40.0));
    }];
    
    // subtitle
    UILabel *subTitleLab = [UILabel labelWithFont:14.0
                                        textColor:RGB(153.0, 153.0, 153.0)
                                        superView:self];
    subTitleLab.textAlignment = NSTextAlignmentCenter;
    subTitleLab.text = subTitle;
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(titleLab.mas_bottom).offset(LayoutH(10.0));;
    }];
    
    // 底部button
    if (buttonTitle.length > 0) {
        ThemeButton *bottomBtn = [[ThemeButton alloc] init];
        bottomBtn.titleLabel.font = FONT(16);
        bottomBtn = [ThemeButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.cloNameN = @"theme_Btn_bg_color";
        bottomBtn.cloNameH = @"theme_Btn_bg_color";
        bottomBtn.titleCloNameN = @"theme_Btn_title_color";
        bottomBtn.titleCloNameH = @"theme_Btn_title_color";
        [bottomBtn setTitle:buttonTitle forState:UIControlStateNormal];
  
        [bottomBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomBtn];
        
        [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subTitleLab.mas_bottom).mas_equalTo(LayoutH(40));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(LayoutW(170));
            make.height.mas_equalTo(LayoutH(46));
        }];
    }
}

- (void)showSubBlankViewWithImage:(NSString *)image
                            title:(NSString *)title isInformation:(BOOL)isInformation {
    // 图片
    UIImage *img = [UIImage imageNamed:image];
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.contentMode = UIViewContentModeScaleToFill;
    contentImageView.image = img;
    self.subBlankImageView = contentImageView;
    [self addSubview:contentImageView];
    
    
    CGFloat imageTopMargin = isInformation ? 10 : 20 ;
    
    if (SCREEN_WIDTH == 320) {
       [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(imageTopMargin);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(LayoutW(130), LayoutH(100)));}];
    } else {
        [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(LayoutH(imageTopMargin));
        make.centerX.equalTo(self);
        }];
    }

    
    // title
    UILabel *titleLab = [UILabel labelWithFont:13.0
                                     textColor:RGB(102, 102, 102)
                                     superView:self];

    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(contentImageView.mas_bottom).offset(LayoutH(20.0));
    }];
}

- (void)setIsFull:(BOOL)isFull {
    
    if (_isFull == isFull) {
        return;
    }
    _isFull = isFull;
    
    
    if (_isFull) {
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self).offset(LayoutH(60));
        }];
    } else {
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(LayoutH(60) + 60);
        }];
    }
}


- (void)bottomBtnClicked:(UIButton *)sender {
    
    if (self.btnClickedBlock) {
        self.btnClickedBlock(sender.tag);
    }
    
}

- (void)imgViewTapClick {
    if (self.imgClickBlock) {
        self.imgClickBlock();
    }
}


@end
