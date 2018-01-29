//
//  UIView+Frame.m
//  YMTextView
//
//  Created by yons on 15/2/13.
//  Copyright © 2015年 lym. All rights reserved.
//

#import "UIImage+YMImg.h"

@implementation UIImage (YMImg)

+ (instancetype)imageWithOriginalName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithStretchableName:(NSString *)imageName  {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (instancetype)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

/**
 图形上下文：主要是对图片进行处理，操作步骤基本如下，可在 2 之前或者之后对上下文进行处理
 
 1 开启一个图形上下文
 2 绘制图片
 3 从当前上下文获取新的图片
 4 关闭上下文
 */

- (UIImage *)circleImageWithSize:(CGSize)size {
    // 1 开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2 绘制图片
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    // 3 从当前上下文获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)circleImageWithSize:(CGSize)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    // 1 开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2 绘制图片
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    
    // 设置边框的宽度
    CGContextSetLineWidth(ctx, borderWidth);
    // 设置边框的颜色
    [borderColor set];
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextStrokePath(ctx);
    
    // 3 从当前上下文获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        // 设置背景填充颜色
        [fillColor setFill];
        UIRectFill(rect);
        // Bezier绘制图形
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [path addClip];
        [self drawInRect:rect];
        // 获得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭
        UIGraphicsEndImageContext();
        // 到主线程中刷新UI, 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
    });
}

- (void)cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth completion:(void (^)(UIImage *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        // 设置背景填充颜色
        [fillColor setFill];
        UIRectFill(rect);
        
        // Bezier绘制图形
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [borderColor setStroke];
        path.lineWidth = borderWidth;
        
        [path addClip];
        [self drawInRect:rect];
        // 获得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
        
    });
}

+ (UIImage *)waterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed {
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

+(instancetype)waterImageWithBgImageName:(NSString *)bgImageName waterImageName:(NSString *)waterImageName scale:(CGFloat)scale {
    // 生成一张有水印的图片，一定要获取UIImage对象 然后显示在imageView上
    
    //创建一背景图片
    UIImage *bgImage = [UIImage imageNamed:bgImageName];
    //NSLog(@"bgImage Size: %@",NSStringFromCGSize(bgImage.size));
    // 1.创建一个位图【图片】，开启位图上下文
    // size:位图大小
    // opaque: alpha通道 YES:不透明/ NO透明 使用NO,生成的更清析
    // scale 比例 设置0.0为屏幕的比例
    // scale 是用于获取生成图片大小 比如位图大小：20X20 / 生成一张图片：（20 *scale X 20 *scale)
    //NSLog(@"当前屏幕的比例 %f",[UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, scale);
    
    // 2.画背景图
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3.画水印
    // 算水印的位置和大小
    // 一般会通过一个比例来缩小水印图片
    UIImage *waterImage = [UIImage imageNamed:waterImageName];
    //#warning 水印的比例，根据需求而定
    CGFloat waterScale = 0.4;
    CGFloat waterW = waterImage.size.width * waterScale;
    CGFloat waterH = waterImage.size.height * waterScale;
    CGFloat waterX = bgImage.size.width - waterW;
    CGFloat waterY = bgImage.size.height - waterH;
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    // 4.从位图上下文获取 当前编辑的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.结束当前位置编辑
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
