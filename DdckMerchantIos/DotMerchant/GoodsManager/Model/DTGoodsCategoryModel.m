//
//  DTGoodsCategoryModel.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/26.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsCategoryModel.h"

@implementation DTGoodsCategoryModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"idField" : @"id"};
}

@end

@implementation DTGoodsCategoryCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTGoodsCategoryModel class]};
}

@end
