//
//  GwUtil.m
//  GwGroup
//
//  Created by gao wenjian on 14-1-13.
//  Copyright (c) 2014年 gao wenjian. All rights reserved.
//

#import "GwUtil.h"
#import "GwDbHelper.h"
@implementation GwUtil

+ (void)loadWorldId
{
    GwDbHelper *helper = [GwDbHelper dbShareInstant];
    if ([helper checkDbFile]) {
        GWLog(@"is exit db data...");
//        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chinaplaces" ofType:@"txt"]];
    NSString *place = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *linerArray = [place componentsSeparatedByString:@"\n"];

   
    [helper openDb];
    
    for (NSString *str in linerArray) {
        NSArray *oneLiner = [str componentsSeparatedByString:@"\t"];
        if (oneLiner.count <= 0) {
            break;
        }else
        {
            if ([[oneLiner objectAtIndex:0] isEqualToString:@"22115895"]) {
                GWLog(@" 22115895 ");
            }
        }
        char *update = "INSERT OR REPLACE INTO FAVOURITES (woeId, iso, name,language,placetype,parentId) VALUES (?,?,?,?,?,?);";
        
        sqlite3_stmt *stmt = nil;
        if (sqlite3_prepare_v2(helper.dbObj, update, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, [[oneLiner objectAtIndex:0] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [[oneLiner objectAtIndex:1] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [[oneLiner objectAtIndex:2] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [[oneLiner objectAtIndex:3] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 5, [[oneLiner objectAtIndex:4] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 6, [[oneLiner objectAtIndex:5] UTF8String], -1, NULL);
        }
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
//            NSAssert(0,@"----- success");
            GWLog(@"------ 插入成功");
        }else
            GWLog(@"------ 插入失败");
        sqlite3_finalize(stmt);
    }
    

    [helper closeDb];
}

+ (void)copyDbToCache
{
    [[GwDbHelper dbShareInstant] copyDbFileDomain];
}

+ (NSDictionary *)parameterCityName:(NSString *)cityName cnt:(NSInteger)cnt
{
    NSDictionary *param = @{@"q":cityName,@"cnt":[NSNumber numberWithInteger:cnt],@"mode":@"json",@"lang":@"zh_cn",@"units":@"metric"};
    return param;
}

+ (NSDictionary *)parameterCityID:(NSInteger)cityId cnt:(NSInteger)cnt
{
    NSDictionary *param = @{@"id":[NSNumber numberWithInteger:cityId],@"cnt":[NSNumber numberWithInteger:cnt],@"mode":@"json",@"lang":@"zh_cn",@"units":@"metric"};
    return param;
}

+ (NSDictionary *)parameterCityCoordinats:(float)lon lat:(float)lat cnt:(NSInteger)cnt;
{
    NSDictionary *param = @{@"lat":[NSNumber numberWithFloat:lat],@"lon":[NSNumber numberWithFloat:lon],@"cnt":[NSNumber numberWithInteger:cnt],@"mode":@"json",@"lang":@"zh_cn",@"units":@"metric"};
    return param;
}


//获取年份
+ (NSInteger)getYear:(NSDate *)date
{
    return [[self getDateComponents:date] year];
}

//获取月份
+ (NSInteger)getMonth:(NSDate *)date
{
    return [[self getDateComponents:date] month];
}

//获取日子
+ (NSInteger)getDay:(NSDate *)date
{
    return [[self getDateComponents:date] day];
}

//获取星期数
+ (NSInteger)weekDay:(NSDate *)date
{
    return [[self getDateComponents:date] weekOfMonth];
}

//获取1个月的天数。
+ (NSInteger)getDaysNum:(NSDate *)date
{
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSRange range =[cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

+ (NSString *)formatGMT:(NSInteger)gmt
{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:gmt];
    NSString *regula = @"yyyy-MM-dd hh:mm:ss";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:regula];
    
    return [formatter stringFromDate:confromTimesp];
}

//add
//初始化日期comp
+ (NSDateComponents *)getDateComponents:(NSDate *)date
{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components=[calendar components:unitFlags fromDate:date];
    return components;
}

//初始化日期格式化
+ (NSDateFormatter *)getFormatter
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return formatter;
}

+ (NSString *)convertWeekDay:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [[self getFormatter] dateFromString:dateString];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;week1是星期天,week7是星期六;
    
    comps = [calendar components:unitFlags fromDate:date];
    GWLog(@"%d",[comps weekday]);
    NSInteger weekDay = [comps weekday];
    NSString *result = @"";
    NSLog(@"weekDay -- %d",weekDay);
    switch (weekDay) {
        case 1:
            result = @"星期日";
            break;
        case 2:
            result = @"星期一";
            break;
        case 3:
            result = @"星期二";
            break;
        case 4:
            result = @"星期三";
            break;
        case 5:
            result = @"星期四";
            break;
        case 6:
            result = @"星期五";
            break;
        case 7:
            result = @"星期六";
            break;
        default:
            break;
    }
    
    return result;
}

@end
