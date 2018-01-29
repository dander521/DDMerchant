//
//  DTGoodsModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/26.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTGoodsModel : NSObject
// 团购价格
@property (nonatomic, strong) NSString * curPrice;
// id
@property (nonatomic, strong) NSString * idField;
// 图片
@property (nonatomic, strong) NSString * img;
// 商品名称
@property (nonatomic, strong) NSString * name;
// 店铺价格
@property (nonatomic, strong) NSString * price;
// 上下架状态
@property (nonatomic, strong) NSString * status;
// 商品标题
@property (nonatomic, strong) NSString * title;



@end

@interface DTGoodsCollectionModel : NSObject

/** 数据源集合 */
@property (nonatomic, strong) NSArray *data;

@end
