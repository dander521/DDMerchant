//
//  DTPaperListModel.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTPaperListModel : NSObject

@property (nonatomic, strong) NSString * curNum;
@property (nonatomic, strong) NSString * deduct;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSArray * paperList;

@end


@interface DTPaperList : NSObject

@property (nonatomic, strong) NSString * deduct;
@property (nonatomic, strong) NSString * face;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * userName;

@end
