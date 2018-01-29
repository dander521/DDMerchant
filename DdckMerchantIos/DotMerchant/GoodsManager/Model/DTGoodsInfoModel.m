//
//  DTGoodsInfoModel.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/26.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsInfoModel.h"

@implementation DTGoodsInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"descs" : [DTGoodsDesModel class]};
}

@end

@implementation DTGoodsDesModel

@end
