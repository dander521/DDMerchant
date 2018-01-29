//
//  DTGoodsCategoryModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/26.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTGoodsCategoryModel : NSObject

// 团购价格
@property (nonatomic, strong) NSString * name;
// id
@property (nonatomic, strong) NSString * idField;

@end

@interface DTGoodsCategoryCollectionModel : NSObject

/** 数据源集合 */
@property (nonatomic, strong) NSArray *data;

@end
