//
//  UIColor+CMKit.m
//  CMKit-HCCategory
//
//  Created by HC on 16/10/26.
//  Copyright © 2016年 HC. All rights reserved.
//

#import "UIColor+CMKit.h"

@implementation UIColor (CMKit)

+ (UIColor * _Nonnull)hex:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString * _Nonnull)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    
    return hexComponent / 255.0;
}

+ (id _Nonnull)colorWithHex:(unsigned int)hex {
    return [UIColor colorWithHex:hex alpha:1.0];
}

+ (id _Nonnull)colorWithHex:(unsigned int)hex alpha:(float)alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:alpha];
}

+ (UIColor * _Nonnull)colorForColorString:(NSString * _Nonnull)colorString {
    if (!colorString) {
        return [UIColor lightGrayColor];
    }
    
    SEL colorSelector = NSSelectorFromString([colorString.lowercaseString stringByAppendingString:@"Color"]);
    if ([UIColor respondsToSelector:colorSelector]) {
        return [UIColor performSelector:colorSelector];
    } else {
        return [UIColor hex:colorString];
    }
}

+ (UIColor * _Nonnull)randomColor {
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}


+ (UIColor * _Nonnull)colorWithColor:(UIColor * _Nonnull)color alpha:(float)alpha {
    return [color colorWithAlphaComponent:alpha];
}

- (void)rgbComponents:(CGFloat [3])components {
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char resultingPixel[4];
    
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 
                                                 1,
                                                 
                                                 1,
                                                 
                                                 8,
                                                 
                                                 4,
                                                 
                                                 rgbColorSpace,
                                                 
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(rgbColorSpace);
    
    
    
    for (int component = 0; component < 3; component++) {
        
        components[component] = resultingPixel[component] / 255.0f;
        
    }
    
}

+ (UIColor * _Nonnull)RGBFromHexColor:(NSString * _Nonnull)hexColor
{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+(UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}
@end
