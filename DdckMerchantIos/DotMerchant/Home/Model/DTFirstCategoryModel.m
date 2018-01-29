//
//  DTFirstCategoryModel.m
//  DotMerchant
//
//  Created by 程荣刚 on 2017/10/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTFirstCategoryModel.h"

@implementation DTFirstCategoryModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation DTFirstCategoryCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTFirstCategoryModel class]};
}

@end
