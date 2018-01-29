//
//  TXModelAchivar.h
//  TailorX
//
//  Created by Qian Shen on 24/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TXUserModel;
@interface TXModelAchivar : NSObject

/**
 * 销售用户信息
 */
+ (TXUserModel *)unachiveUserModel;


+ (void)achiveUserModel;

+ (void)updateUserModelWithKey:(NSString *)key value:(NSString *)value;

+ (TXUserModel *)getUserModel;

@end
