//
//  DTGoodsModel.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/26.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsModel.h"

@implementation DTGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"idField" : @"id"};
}

@end

@implementation DTGoodsCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTGoodsModel class]};
}

@end
