//
//  NSString+Extension.m
//  Tailorx
//
//  Created by yons on 17/1/22.
//  Copyright © 2017年   徐安超. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


/**
 * 判断手机号码是否正确
 */
+ (BOOL)isPhoneNumCorrectPhoneNum:(NSString *)phoneNum {
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneNum.length != 11)
    {
        return NO;
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"(^13[0-9]{9}$|14[0-9]{9}|15[0-9]{9}$|18[0-9]{9}$|17[0-9]{9}$)";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"(^1(33|53|77|79|8[019])\\d{8}$)|(^1700\\d{7}$)";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phoneNum];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phoneNum];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phoneNum];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

/**
 *正则匹配用户姓名, 20 位的中文或英文
 */

+ (BOOL)checkUserName:(NSString *)userName
{
    NSString *pattern = @"^[a-zA-Z一-龥]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}

/**
 * 密码验证
 */
-(BOOL)checkPassWord
{
    //6-20位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:self]) {
        return YES ;
    }else
        return NO;
}


/**
 * 正则匹配用户身份证号15或18位
 */

+ (BOOL)checkUserIdCard:(NSString *)idCard {
    
    idCard = [idCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    
    if (!idCard) {
        return NO;
    }else {
        length = idCard.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [idCard substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) {
        return false;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    switch (length) {
        case 15:
            year = [idCard substringWithRange:NSMakeRange(6,2)].intValue + 1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCard.length)];
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [idCard substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCard
                                                               options:NSMatchingReportProgress
                             
                                                                 range:NSMakeRange(0, idCard.length)];
            if(numberofMatch >0) {
                int S = ([idCard substringWithRange:NSMakeRange(0,1)].intValue + [idCard substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([idCard substringWithRange:NSMakeRange(1,1)].intValue + [idCard substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([idCard substringWithRange:NSMakeRange(2,1)].intValue + [idCard substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([idCard substringWithRange:NSMakeRange(3,1)].intValue + [idCard substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([idCard substringWithRange:NSMakeRange(4,1)].intValue + [idCard substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([idCard substringWithRange:NSMakeRange(5,1)].intValue + [idCard substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([idCard substringWithRange:NSMakeRange(6,1)].intValue + [idCard substringWithRange:NSMakeRange(16,1)].intValue) *2 + [idCard substringWithRange:NSMakeRange(7,1)].intValue *1 + [idCard substringWithRange:NSMakeRange(8,1)].intValue *6 + [idCard substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[idCard substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        default:
            return false;
    }
}


/**
 判断字符串是否为空

 @param string 需要判断的字符串
 @return Yes：为空，NO：非空
 */
+(BOOL)isTextEmpty:(NSString *)string{
    //判断字符串为空
    if (string == nil || (id)string == [NSNull null]|| [string isEqualToString:@""] || [string isEqualToString:@"(null)"]) {
        return YES;
    }else{
        if (![string respondsToSelector:@selector(length)]) {
            return YES;
        }
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([string length]) {
            return NO;
        }
    }
    return YES;
    
}

/**
 分隔显示电话号码
 
 @return
 */
+ (NSString *)seperateTelephoneString:(NSString *)telephone {
    if ([telephone length] != 11 || [NSString isTextEmpty:telephone]) {
        return telephone;
    }
    
    NSString *foreward = [telephone substringToIndex:3];
    NSString *backward = [telephone substringFromIndex:7];
    NSRange range = NSMakeRange(3, 4);
    NSString *middle = [telephone substringWithRange:range];
    
    return [NSString stringWithFormat:@"%@ %@ %@", foreward, middle, backward];
}

/**
 label中的某个文字的颜色和字体
 
 @param string
 @param color
 @param range
 @param font
 @return
 */
+ (NSMutableAttributedString *)setAttributedString:(NSString *)string color:(UIColor *)color rang:(NSRange)range font:(id)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    //设置颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    //设置尺寸
    [attributedString addAttribute:NSFontAttributeName value:font range:range]; // 0为起始位置 length是从起始位置开始 设置指定字体尺寸的长度
    return attributedString;
}

//进行邮箱正则表达式判断
+ (BOOL)validateEmail:(NSString*)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

/**
 根据photo拼接用户头像的全路径

 @param photo 头像链接
 @return 全路径
 */
+ (NSString*)getStrUserPhoto:(NSString*)photo {
    NSString *strPicture = @"http://cdn.tailorx.cn";//图片
    NSString *str_userphoto = @"/picture/userphoto/";//用户头像
    return [NSString stringWithFormat:@"%@%@%@",strPicture,str_userphoto, photo];
}



+ (NSString *)disableEmoji:(NSString *)text
{
    if (!text.length) return text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}
@end
