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

+ (NSDictionary *)parameterCityName:(NSString *)cityName
{
    NSDictionary *param = @{@"q":cityName,@"cnt":@"7",@"mode":@"json",@"lang":@"zh_cn",@"units":@"metric"};
    return param;
}

+ (NSDictionary *)parameterCityID:(NSInteger)cityId
{
    NSDictionary *param = @{@"id":[NSNumber numberWithInteger:cityId],@"cnt":@"1",@"mode":@"json",@"lang":@"zh_cn",@"units":@"metric"};
    return param;
}

+ (NSDictionary *)parameterCityCoordinats:(float)lon lat:(float)lat;
{
    NSDictionary *param = @{@"lat":[NSNumber numberWithFloat:lat],@"lon":[NSNumber numberWithFloat:lon],@"cnt":@"1",@"mode":@"json",@"lang":@"zh_cn",@"units":@"metric"};
    return param;
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

@end
