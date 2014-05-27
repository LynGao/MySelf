//
//  GwWeatherBi.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-9.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GwBaseBi.h"

@interface GwWeatherBi : GwBaseBi

/**
 *  获取7天的天气情况
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 *  @param cityId       城市id
 */
- (void)getForcastWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock ById:(NSInteger)cityId;

/**
 *  获取7天的天气情况
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 *  @param cityName       城市名
 */
- (void)getForcastWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock cityName:(NSString *)cityName;

/**
 *  获取7天的天气情况
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 *  @param lon           经度
 *  @param lat           纬度
 */
- (void)getForcastWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock lon:(float)lon lat:(float)lat;


/**
 *  获取当前的天气情况
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 *  @param cityId       城市id
 */
- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock ById:(NSInteger)cityId;

/**
 *  获取当前的天气情况
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 *  @param cityName       城市名
 */
- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock cityName:(NSString *)cityName;

/**
 *  获取当前的天气情况
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 *  @param lon           经度
 *  @param lat           纬度
 */
- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock lon:(float)lon lat:(float)lat;


/**
 *  获取当前6个小时的情况
 *
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 *  @param lon           经度
 *  @param lat           纬度
 */
- (void)getForcastSixHour:(GetDataFinish)successBlock fail:(GetDataFail)failBlock lon:(NSString *)lon lat:(NSString *)lat;


- (void)loadAllRequest:(void (^)(NSDictionary *dict))reult;

@end
