//
//  DTStoreModel.m
//  DotMerchant
//
//  Created by 程荣刚 on 2017/10/25.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTStoreModel.h"

@implementation DTStoreModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"type" : [DTStoreType class]};
}

@end

@implementation DTStoreType

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end


