//
//  DTOrderListModel.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderListModel.h"

@implementation DTOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTOrderModel class]};
}

@end


@implementation DTOrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation DTOrderListCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTOrderListModel class]};
}

@end
