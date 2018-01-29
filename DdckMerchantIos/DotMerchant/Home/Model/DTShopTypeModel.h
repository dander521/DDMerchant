//
//  DTShopTypeModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2018/1/16.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTShopTypeModel : NSObject

@property (nonatomic, strong) NSString *firstTypeId;
@property (nonatomic, strong) NSString *firstName;

@end

@interface DTShopTypeCollectionModel : NSObject

/**  */
@property (nonatomic, strong) NSArray *data;

@end
