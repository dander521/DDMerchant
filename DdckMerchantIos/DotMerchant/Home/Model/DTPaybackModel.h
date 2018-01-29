//
//  DTPaybackModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTPaybackModel : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * maxRate;
@property (nonatomic, strong) NSString * minRate;
@property (nonatomic, strong) NSString * minRateConf;
@property (nonatomic, strong) NSString * rate;
@property (nonatomic, strong) NSString * shopId;
@property (nonatomic, strong) NSString * type;

@end
