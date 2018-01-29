//
//  DTGoodsInfoModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/26.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTGoodsInfoModel : NSObject

// 团购价格
@property (nonatomic, strong) NSString * curPrice;
// 商品ID
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
// 商品分类ID
@property (nonatomic, strong) NSString * type;
// 商品分类ID
@property (nonatomic, strong) NSString * typeName;
// 商品分类ID
@property (nonatomic, strong) NSString * firstTypeId;
// 商品分类名称
@property (nonatomic, strong) NSString * firstTypeName;
// 0
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * details;

@property (nonatomic, strong) NSArray *descs;

@end

@interface DTGoodsDesModel : NSObject

@property (nonatomic, strong) NSString *firstParam;
@property (nonatomic, strong) NSString *twoParam;
@property (nonatomic, strong) NSString *threeParam;
@property (nonatomic, assign) BOOL isFull;

@end
