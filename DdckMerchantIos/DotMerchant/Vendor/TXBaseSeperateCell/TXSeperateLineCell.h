//
//  TXSeperateLineCell.m
//  TailorX
//
//  Created by 倩倩 on 17/4/19.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TXCellSeperateLinePositionType) {
    TXCellSeperateLinePositionType_None = 0, /**<无分割线 cell */
    TXCellSeperateLinePositionType_Single /**<单分隔线 cell */
};

typedef NS_ENUM(NSUInteger, TXCellRightMarginType) {
    TXCellRightMarginType0 = 0,
    TXCellRightMarginType16,
    TXCellRightMarginType20,
    TXCellRightMarginType47,
    TXCellRightMarginType131,
    TXCellRightMarginType159,
    TXCellRightMarginType95
};

@interface TXSeperateLineCell : UITableViewCell
/** 分割线类型 */
@property (nonatomic) TXCellSeperateLinePositionType cellLineType;
/** 分割线右侧距离 */
@property (nonatomic, assign) TXCellRightMarginType cellLineRightMargin;

/**
 AccessoryView
 
 @return 箭头
 */
- (UIImageView *)setCustomAccessoryView;

@end
