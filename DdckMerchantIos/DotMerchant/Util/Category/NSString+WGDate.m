//
//  NSString+WGDate.m
//  WildGrass
//
//  Created by yons on 16/11/15.
//  Copyright © 2016年 Mr.Chang. All rights reserved.
//

#import "NSString+WGDate.h"

@implementation NSString (WGDate)
+ (NSString *)getTimeInterval
{
    NSDate * date = [NSDate date];
    NSInteger timeInterval = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(long)timeInterval];
}
+(NSString *)formatDate:(double)timesp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}
/**
 *  时间格式：yyyy-MM-dd
 */
+(NSString *)formatDateLine:(double)timesp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+(NSString *)formatDateToSecond:(double)timesp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+(NSString *)formatDateToMin:(double)timesp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)formatDateMMDDHHMM:(double)timesp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)formatNewsDate:(long long)time{
    
    NSString *dateStr = nil;
    long long nowTime = [[NSDate date] timeIntervalSince1970];
    if (time + 60 >= nowTime) {
        dateStr = [NSString stringWithFormat:@"刚刚"];
    } else if (time + 60 * 60 >= nowTime) {
        long long minute = (nowTime - time) / 60;
        dateStr = [NSString stringWithFormat:@"%lld分钟前", minute];
    } else if (time + 60 * 60 * 24 >= nowTime) {
        long long hour = (nowTime - time) / (60 * 60);
        dateStr = [NSString stringWithFormat:@"%lld小时前", hour];
    } else {
        dateStr = [NSString stringWithFormat:@"%@", [self formatDateMMDDHHMM:time]];
    }
    
    return dateStr;
}
+ (NSString*)getDateStringWithTimestamp:(NSTimeInterval)timestamp
{
    NSDate *confromTimesp    = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceYear  =referenceComponents.year;
    NSInteger referenceMonth =referenceComponents.month;
    NSInteger referenceDay   =referenceComponents.day;
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)referenceYear,(long)referenceMonth,(long)referenceDay];
}

/**
 获取剩余时间 秒
 
 @param timeInterval 时间戳
 @return
 */
+ (NSString *)getLastTimeWithTimeInterval:(NSTimeInterval)timeInterval {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d", 30*60 - ((int)((int)now - timeInterval/1000))];
}

@end
