//
//  DTOrderListViewController.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

@interface DTOrderListViewController : UIViewController <ZJScrollPageViewChildVcDelegate>

@property (nonatomic, assign) NSInteger cellType;

@end
