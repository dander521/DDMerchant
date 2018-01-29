//
//  DTCouponInfoModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/12/25.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCouponInfoModel : NSObject

// 抵用价格
@property (nonatomic, strong) NSString * usePrice;
// id
@property (nonatomic, strong) NSString * idField;
// 商品名称
@property (nonatomic, strong) NSString * remark;
// 店铺价格
@property (nonatomic, strong) NSString * price;

@end
