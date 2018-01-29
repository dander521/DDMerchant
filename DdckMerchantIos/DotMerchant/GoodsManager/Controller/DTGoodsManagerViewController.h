//
//  DTGoodsManagerViewController.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
#import "DTGoodsTableViewCell.h"

@interface DTGoodsManagerViewController : UIViewController <ZJScrollPageViewChildVcDelegate>

@property (nonatomic, assign) DTGoodsTableViewCellType cellType;
@property (nonatomic, assign) BOOL isGoods;
@end
