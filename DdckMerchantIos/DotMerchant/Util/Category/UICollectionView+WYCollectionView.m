//
//  UICollectionView+WYCollectionView.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/21.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UICollectionView+WYCollectionView.h"

@implementation UICollectionView (WYCollectionView)

+ (UICollectionView *)createWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor layout:(UICollectionViewFlowLayout *)layout superView:(UIView *)superView delegate:(id)delegate cellClass:(__unsafe_unretained Class)cellClass identifier:(NSString *)identifier {
    
    UICollectionView *view = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    view.backgroundColor = bgColor;
    [view registerClass:cellClass forCellWithReuseIdentifier:identifier];
    view.delegate = delegate;
    view.dataSource = delegate;
    [superView addSubview:view];
    
    return view;
}

+ (UICollectionView *)createWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor layout:(UICollectionViewFlowLayout *)layout superView:(UIView *)superView delegate:(id)delegate {
    
    UICollectionView *view = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    view.backgroundColor = bgColor;
    view.delegate = delegate;
    view.dataSource = delegate;
    [superView addSubview:view];
    
    return view;
}

@end
