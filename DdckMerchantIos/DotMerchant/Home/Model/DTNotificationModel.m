//
//  DTNotificationModel.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTNotificationModel.h"

@implementation DTNotificationModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTNotificationSubModel class]};
}

@end

@implementation DTNotificationCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTNotificationModel class]};
}

@end


@implementation DTNotificationSubModel

@end
