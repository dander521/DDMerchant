//
//  DTCommentModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCommentModel : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * face;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray * replyList;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, strong) NSString * time;

@end

@interface DTReplyModel : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * name;

@end

@interface DTCommentCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
