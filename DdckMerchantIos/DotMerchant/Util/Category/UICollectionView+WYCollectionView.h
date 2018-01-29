//
//  UICollectionView+WYCollectionView.h
//  UChat
//
//  Created by 钩钩硬 on 16/1/21.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (WYCollectionView)
/**
 快速创建集合视图

 @param frame frame
 @param bgColor 背景颜色
 @param layout layout
 @param superView 其父视图
 @param delegate 代理
 @param cellClass cell的类型
 @param identifier cell的标识
 
 @return UICollectionView *
 */
+ (UICollectionView *)createWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor layout:(UICollectionViewFlowLayout *)layout superView:(UIView *)superView delegate:(id)delegate cellClass:(Class)cellClass identifier:(NSString *)identifier;
/**
 快速创建集合视图

 @param frame frame
 @param bgColor 背景颜色
 @param layout layout
 @param superView 其父视图
 @param delegate 代理
 
 @return UICollectionView *
 */
+ (UICollectionView *)createWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor layout:(UICollectionViewFlowLayout *)layout superView:(UIView *)superView delegate:(id)delegate;

@end
