//
//  DTNotificationModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTNotificationModel : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * orderStatus;
@property (nonatomic, strong) NSString * orderTime;
@property (nonatomic, strong) NSString * pImg;
@property (nonatomic, strong) NSString * pName;
@property (nonatomic, strong) NSString * pNum;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSArray *list;

@end

@interface DTNotificationSubModel : NSObject

@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * type;

@end

@interface DTNotificationCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
