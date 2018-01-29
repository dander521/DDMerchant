//
//  DTOrderListModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTOrderListModel : NSObject

@property (nonatomic, strong) NSString * face;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * orderPrice;
@property (nonatomic, strong) NSString * orderType;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * productId;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * productNum;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * sendPrice;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSArray * list;


@end

@interface DTOrderModel : NSObject

@property (nonatomic, strong) NSString * assessFlag;
@property (nonatomic, strong) NSString * dataId;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * title;

@end

@interface DTOrderListCollectionModel : NSObject

/**  */
@property (nonatomic, strong) NSArray *data;

@end
