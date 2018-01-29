//
//  XRWaterfallLayout.m
//  TailorX
//
//  Created by Qian Shen on 16/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "XRWaterfallLayout.h"
/*      默认值    */
static const CGFloat inset = 8;
static const CGFloat colCount = 2;

@interface XRWaterfallLayout ()

//多维数组 每个区的item的attributes是一个子数组
@property (nonatomic, strong)NSMutableDictionary *secColDics;

@property (nonatomic, strong) NSMutableDictionary *colunMaxYDic;

@end

@implementation XRWaterfallLayout

#pragma mark- 构造方法
- (instancetype)init {
    if (self = [super init]) {
        self.itemSpacing = inset;
        self.lineSpacing = inset;
        self.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        self.colCount = colCount;
        self.stickyHeader = YES;
        self.secColDics = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark -动态获取 间距 列数 和 区内边距
/**
 *垂直间距
 
 @param indexPath indexPath
 @return value
 */
- (CGFloat)colSpaWithIP:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:interitemSpacingForSectionAtIndex:)]) {
        return [_delegate collectionView:self.collectionView layout:self interitemSpacingForSectionAtIndex:indexPath.section];
    }else {
        return self.itemSpacing;
    }
}

/**
 *行间距
 
 @param indexPath indexPath
 @return value
 */
- (CGFloat)rowSpaWithIP:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector: @selector(collectionView:layout:lineSpacingForSectionAtIndex:)]) {
        return [_delegate collectionView:self.collectionView layout:self lineSpacingForSectionAtIndex:indexPath.section];
    }else {
        return self.lineSpacing;
    }
}

/**
 *区内边距
 
 @param indexPath indexPath
 @return value
 */
- (UIEdgeInsets)secInsetWithIP:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [_delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    }else {
        return self.sectionInset;
    }
}

//指定区的列数
/**
 *获得区列数
 
 @param indexPath indexPath
 @return value
 */
- (NSInteger)colCountWithIP:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:colCountForSectionAtIndex:)]) {
        return [_delegate collectionView:self.collectionView layout:self colCountForSectionAtIndex:indexPath.section];
    }else {
        return self.colCount;
    }
}

#pragma mark- 布局相关方法
//布局前的准备工作
- (void)prepareLayout {
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return self.stickyHeader;
}

//计算collectionView的contentSize
- (CGSize)collectionViewContentSize {
    
    __block NSString * maxCol = @"0";
    NSMutableDictionary *colunMaxYDic = [self secColDicsWith:[NSIndexPath indexPathForItem:0 inSection:[self.collectionView numberOfSections]-1]];
    //遍历找出最高的列
    [colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [colunMaxYDic[maxCol] floatValue]) {
            maxCol = column;
        }
    }];
    
    return CGSizeMake(0, [colunMaxYDic[maxCol] floatValue]);
}

#pragma mark - 计算item大小属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block NSString * minCol = @"0";
    
    NSMutableDictionary *colunMaxYDic = [self secColDicsWith:indexPath];
    
    //遍历找出最短的列
    [colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [colunMaxYDic[minCol] floatValue]) {
            minCol = column;
        }
    }];
    
    //    宽度
    CGFloat width = (self.collectionView.frame.size.width - [self secInsetWithIP:indexPath].left - [self secInsetWithIP:indexPath].right- ([self colCountWithIP:indexPath]-1) * [self colSpaWithIP:indexPath])/[self colCountWithIP:indexPath];
    //    高度
    CGFloat height = 0;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForWidth:atIndexPath:)]) {
        height = [self.delegate collectionView:self.collectionView layout:self heightForWidth:width atIndexPath:indexPath];
    }
    
    CGFloat x = [self secInsetWithIP:indexPath].left + (width + [self colSpaWithIP:indexPath]) * [minCol intValue];
    
    CGFloat space = 0.0;
    if (indexPath.item < [self colCountWithIP:indexPath]) {
        space = [self secInsetWithIP:indexPath].top;
    }else{
        space = [self rowSpaWithIP:indexPath];
    }
    CGFloat y =[colunMaxYDic[minCol] floatValue] + space;
    
    //    跟新对应列的高度
    colunMaxYDic[minCol] = @(y + height);
    
    //    计算位置
    UICollectionViewLayoutAttributes * attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.frame = CGRectMake(x, y, width, height);
    
    return attri;
}

#pragma mark - 计算头和尾大小属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    __block NSString * maxCol = @"0";
    NSMutableDictionary *colunMaxYDic = [self secColDicsWith:indexPath];
    
    //遍历找出最高的列
    [colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [colunMaxYDic[maxCol] floatValue]) {
            maxCol = column;
        }
    }];
    
    //header
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        //size
        CGSize size = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        }
        
        //修正每个区的位置字典
        [self resetSecColDicMaxY];
        
        CGFloat x = 0;
        
        CGFloat y = [[colunMaxYDic objectForKey:maxCol] floatValue];
        
        //更新所有对应列的高度
        for(NSString *key in colunMaxYDic.allKeys)
        {
            colunMaxYDic[key] = @(y + size.height);
            
        }
        
        attri.frame = CGRectMake(x , y, size.width, size.height);
        return attri;
    }
    
    //footer
    else{
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        //size
        CGSize size = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        }
        CGFloat x = 0;
        CGFloat y = [[colunMaxYDic objectForKey:maxCol] floatValue] + [self secInsetWithIP:indexPath].bottom;
        
        //更新所有对应列的高度
        for(NSString *key in colunMaxYDic.allKeys)
        {
            colunMaxYDic[key] = @(y + size.height);
        }
        
        attri.frame = CGRectMake(x , y, size.width, size.height);
        return attri;
    }
}

#pragma mark - 提交item属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSInteger section = [self.collectionView numberOfSections];
    
    //重置每个区的位置字典
    for (NSInteger i = 0; i < section; i++) {
        NSMutableDictionary *dic = [self secColDicsWith:[NSIndexPath indexPathForItem:0 inSection:i]];
        
        
        for(NSInteger j = 0;j < [self colCountWithIP:[NSIndexPath indexPathForItem:0 inSection:i]]; j++)
        {
            NSString * col = [NSString stringWithFormat:@"%ld",(long)j];
            dic[col] = [NSNumber numberWithFloat:0];
        }
    }
    
    NSMutableArray * attrsArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < section; i++) {
        
        
        //获取header的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [attrsArray addObject:headerAttrs];
        
        //获取item的UICollectionViewLayoutAttributes
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [attrsArray addObject:attrs];
        }
        
        //获取footer的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [attrsArray addObject:footerAttrs];
    }
    
    return attrsArray;
}

- (NSMutableDictionary *)secColDicsWith:(NSIndexPath *)indexPath {
    NSString * sec = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSMutableDictionary *dic = self.secColDics[sec];
    if (!dic) {
        dic = [[NSMutableDictionary alloc]init];
        [self.secColDics setObject:dic forKey:sec];
    }
    return dic;
}

/**
 *修正每个区的位置字典
 */
- (void)resetSecColDicMaxY {
    NSInteger section = [self.collectionView numberOfSections];
    __block NSString * maxCol = @"0";
    CGFloat maxY = 0;
    CGFloat totalMaxY = 0;
    
    for (NSInteger i = 0; i < section; i++) {
        NSMutableDictionary *dic = [self secColDicsWith:[NSIndexPath indexPathForItem:0 inSection:i]];
        
        //遍历找出最高的列
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
            if ([maxY floatValue] > [dic[maxCol] floatValue]) {
                maxCol = column;
            }
        }];
        
        maxY = [[dic objectForKey:maxCol] floatValue];
        
        for(NSInteger j = 0;j < [self colCountWithIP:[NSIndexPath indexPathForItem:0 inSection:i]]; j++)
        {
            NSString * col = [NSString stringWithFormat:@"%ld",(long)j];
            dic[col] = [NSNumber numberWithFloat:totalMaxY];
        }
        totalMaxY = maxY;
    }
}
@end
