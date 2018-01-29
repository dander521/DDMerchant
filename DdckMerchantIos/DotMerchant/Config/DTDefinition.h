//
//  DTDefinition.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#ifndef DTDefinition_h
#define DTDefinition_h

#pragma mark - Font
/*****************************************Font***********************************************/
#define FONT(frontSize) [UIFont systemFontOfSize:frontSize]
#define FRONTWITHSIZE(frontSize) [UIFont fontWithName:@"MicrosoftYaHei" size:frontSize]
#define FONTType(type,frontSize) [UIFont fontWithName:type size:frontSize]
/*****************************************Font***********************************************/

#pragma mark - Color
/*****************************************Color***********************************************/
#define RGB(__r, __g, __b)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:1.0]
#define RGBA(__r, __g, __b, __a)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:__a]
#define LightColor RGB(247, 247, 247)
#define RedColor RGB(246, 47, 94)
#define TitleTextColor RGB(108, 108, 108)
#define StateTextColor RGB(153, 153, 153)
#define DefaultBlackColor RGB(51, 51, 15)
/*****************************************Color***********************************************/

#define weakSelf(myself) __weak typeof(myself) weakSelf = myself;

#pragma mark - SingleTon
/*****************************************SingleTon***********************************************/
// 单例化一个类
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
/*****************************************SingleTon***********************************************/

#pragma mark - Frame
/*****************************************Frame***********************************************/
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.width

#define TRENDVC_HEIGHT [[UIScreen mainScreen] bounds].size.height - (64 + 44 + 49)

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define W(w) [[UIScreen mainScreen] bounds].size.width / 320 * w
#define H(h)  ([[UIScreen mainScreen] bounds].size.height > 568? [[UIScreen mainScreen] bounds].size.height : 568) / 568 * h
#define LayoutW(w)  [[UIScreen mainScreen] bounds].size.width / 375 * w
#define LayoutH(h)  ([[UIScreen mainScreen] bounds].size.height > 667 ? [[UIScreen mainScreen] bounds].size.height : 667) / 667 * h
#define SizeScale ([[UIScreen mainScreen] bounds].size.width >= 375 ? 1 : [[UIScreen mainScreen] bounds].size.width / 375)
#define LayoutF(f)  [UIFont systemFontOfSize:f * SizeScale]
/*****************************************Frame***********************************************/

#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

#define CLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define alipayScheme @"DotMerchant"
#define ServerResponse_resultStatus             @"resultStatus"
#define ServerResponse_alipayCodeSuccess        @"9000"
#define ServerResponse_alipayCodeDealing        @"8000"
#define ServerResponse_alipayCodeCancel         @"6001"
#define ServerResponse_alipayCodeFail           @"4000"

#endif /* DTDefinition_h */
