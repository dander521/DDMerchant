//
//  TXBlankView.h
//  TailorX
//
//  Created by 温强 on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FirstButtonTag  1000000
#define SecondButtonTag 2000000

typedef void (^BlankViewBtnClickedBlock)(NSInteger buttonTag);

@interface TXBlankView : UIView
/** 整页空白页的图标 */
@property (nonatomic, assign) UIImageView *imgView;
/** 局部空白页的图标（资讯筛选空白页，资讯详情评论空白页）  */
@property (nonatomic, assign) UIImageView *subBlankImageView;
// 底部按钮回调block
@property(nonatomic, copy) BlankViewBtnClickedBlock btnClickedBlock;
@property(nonatomic, assign) BOOL isFull;
// 图片点击回调
@property (nonatomic, copy) void(^imgClickBlock)();

/**
 带 图片/单行提示语 的空白页
 
 @param image 图片名
 @param title 主提示语

 */
- (void)createBlankViewWithImage:(NSString *)image
                           title:(NSString *)title;

/**
 带 图片/单行提示语/底部按钮 的空白页
 
 @param image 图片名
 @param title 主提示语
 @param buttonTitle 底部按钮title
 */
- (void)createBlankViewWithImage:(NSString *)image
                           title:(NSString *)title
                     buttonTitle:(NSString *)buttonTitle;

/**
 带 图片/两行提示语 的空白页
 
 @param image 图片名
 @param title 主提示语
 @param subTitle 副提示语

 */
- (void)createBlankViewWithImage:(NSString *)image
                           title:(NSString *)title
                        subTitle:(NSString *)subTitle;

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
                     buttonTitle:(NSString *)buttonTitle;

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
                     buttonTitle:(NSString *)secondButtonTitle;

/**
 带 图片/两行提示语/底部按钮 的空白页 ------ btn在subTitle下面
 
 @param image 图片名
 @param title 主提示语
 @param subTitle 副提示语
 @param buttonTitle 底部按钮title
 */

- (void)showBlankViewWithImage:(NSString *)image
                         title:(NSString *)title
                      subTitle:(NSString *)subTitle
                   buttonTitle:(NSString *)buttonTitle;

/**
 资讯列表的空白页 ------ btn在subTitle下面
 
 @param image 图片名
 @param title 主提示语
 */
- (void)showSubBlankViewWithImage:(NSString *)image
                            title:(NSString *)title isInformation:(BOOL)isInformation;
@end
