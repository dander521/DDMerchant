//
//  DTCouponModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/12/25.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCouponModel : NSObject

// 抵用价格
@property (nonatomic, strong) NSString * usePrice;
// id
@property (nonatomic, strong) NSString * idField;
// 商品名称
@property (nonatomic, strong) NSString * remark;
// 店铺价格
@property (nonatomic, strong) NSString * price;
// 上下架状态
@property (nonatomic, strong) NSString * status;


@end

@interface DTCouponCollectionModel : NSObject

/** 数据源集合 */
@property (nonatomic, strong) NSArray *data;

@end

