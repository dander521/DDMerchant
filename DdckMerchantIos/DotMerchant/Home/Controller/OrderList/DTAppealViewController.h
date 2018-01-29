//
//  DTAppealViewController.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"

@interface DTAppealViewController : UIViewController

/** <#description#> */
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) DTOrderListModel *model;

@end
