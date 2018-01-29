//
//  NSString+Extension.h
//  Tailorx
//
//  Created by yons on 17/1/22.
//  Copyright © 2017年   徐安超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 * 判断手机号码是否正确
 */
+ (BOOL)isPhoneNumCorrectPhoneNum:(NSString *)phoneNum;

//正则匹配用户姓名, 20 位的中文或英文
+ (BOOL)checkUserName:(NSString *)userName;

/**
 * 密码验证 6-18
 */
-(BOOL)checkPassWord;

/**
 * 正则匹配用户身份证号15或18位
 */

+ (BOOL)checkUserIdCard:(NSString *)idCard;

/**
 判断字符串是否为空
 
 @param string 需要判断的字符串
 @return Yes：为空，NO：非空
 */

+(BOOL)isTextEmpty:(NSString *)string;


/**
 分隔显示电话号码

 @return
 */
+ (NSString *)seperateTelephoneString:(NSString *)telephone;


/**
 label中的某个文字的颜色和字体

 @param string
 @param color
 @param range
 @param font
 @return
 */
+ (NSMutableAttributedString *)setAttributedString:(NSString *)string color:(UIColor *)color rang:(NSRange)range font:(id)font;

//进行邮箱正则表达式判断
+ (BOOL)validateEmail:(NSString*)email;

/**
 根据photo拼接用户头像的全路径
 
 @param photo 头像链接
 @return 全路径
 */
+ (NSString*)getStrUserPhoto:(NSString*)photo;


+ (NSString *)disableEmoji:(NSString *)text;
@end
