//
//  DTCommentModel.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCommentModel.h"

@implementation DTCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"replyList" : [DTReplyModel class]};
}

@end

@implementation DTReplyModel

@end

@implementation DTCommentCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTCommentModel class]};
}

@end
