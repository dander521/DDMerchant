//
//  DTCouponModel.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/12/25.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCouponModel.h"

@implementation DTCouponModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"idField" : @"id"};
}

@end

@implementation DTCouponCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTCouponModel class]};
}

@end

