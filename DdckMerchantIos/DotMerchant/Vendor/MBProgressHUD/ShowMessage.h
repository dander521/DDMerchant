//
//  ShowMessage.h
//  LoginDemo
//
//  Created by   徐安超 on 16/6/16.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowMessage : NSObject

+(void)showMessage:(NSString*)message;

+(void)showMessage:(NSString *)message withCenter:(CGPoint)center;
+(void)showMessage:(NSString *)message size:(NSString * )sizeter;

@end
