//
//  GwUtil.h
//  GwGroup
//
//  Created by gao wenjian on 14-1-13.
//  Copyright (c) 2014年 gao wenjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GwUtil : NSObject

+ (void)loadWorldId;

+ (void)copyDbToCache;

/**
 *  组装Get方法参数
 *
 *  @param cityName 城市名
 *
 *  @return nsdict
 */
+ (NSDictionary *)parameterCityName:(NSString *)cityName cnt:(NSInteger)cnt;

/**
 *  组装Get方法参数
 *
 *  @param cityId 城市编号
 *
 *  @return nsdict
 */
+ (NSDictionary *)parameterCityID:(NSInteger)cityId cnt:(NSInteger)cnt;

/**
 *  组装Get方法参数
 *
 *  @param lat 纬度
 *
 *  @param lon 经度
 *
 *  @return nsdict
 */
+ (NSDictionary *)parameterCityCoordinats:(float)lon lat:(float)lat cnt:(NSInteger)cnt;


/** ****************** Common Util ******************* **/

+ (NSString *)formatGMT:(NSInteger)gmt;

+ (NSString *)convertWeekDay:(NSString *)dateString;

@end
