//
//  TXModelAchivar.m
//  TailorX
//
//  Created by Qian Shen on 24/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXModelAchivar.h"
#import "TXUserModel.h"
@implementation TXModelAchivar

+(TXUserModel *)unachiveUserModel{
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivepath:@"TXUserModel"]];
    
}

+(void)achiveUserModel{
    
    BOOL flag=[NSKeyedArchiver archiveRootObject:[TXUserModel defaultUser] toFile:[self archivepath:@"TXUserModel"]];
    if (!flag) {
        NSLog(@"归档失败");
    }
    
}


+(NSString *)archivepath:(NSString *)path{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basepath=([paths count]>0)?[paths objectAtIndex:0]:nil;
    return [basepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.us",path]];
    
}

+ (void)updateUserModelWithKey:(NSString *)key value:(NSString *)value {
    [[TXUserModel defaultUser] setValue:value forKey:key];
    [TXModelAchivar achiveUserModel];
}

+ (TXUserModel *)getUserModel {
    return ((TXUserModel*)[TXModelAchivar unachiveUserModel]);
}

@end
