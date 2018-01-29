//
//  DTStatisticsModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTStatisticsModel : NSObject

/** <#description#> */
@property (nonatomic, strong) NSString *income;
/**  */
@property (nonatomic, strong) NSString *time;

@end

@interface DTStatisticsCollectionModel : NSObject

/** <#description#> */
@property (nonatomic, strong) NSArray *data;

@end
