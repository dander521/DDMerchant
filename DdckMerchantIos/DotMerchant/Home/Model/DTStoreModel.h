//
//  DTStoreModel.h
//  DotMerchant
//
//  Created by 程荣刚 on 2017/10/25.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTStoreType;

@interface DTStoreModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * lon;
@property (nonatomic, strong) NSString * minIcon;
@property (nonatomic, strong) NSString * maxIcon;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSString * street;

@property (nonatomic, strong) NSString * noticeStr;

@property (nonatomic, strong) NSArray <DTStoreType *>* type;

@end

@interface DTStoreType : NSObject

@property (nonatomic, strong) NSString * firstTypeId;
@property (nonatomic, strong) NSString * firstTypeName;
@property (nonatomic, strong) NSString * twoTypeName;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * twoTypeId;

@end
