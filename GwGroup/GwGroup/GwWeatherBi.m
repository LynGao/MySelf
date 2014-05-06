//
//  GwWeatherBi.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-9.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwWeatherBi.h"

#import "AFHTTPRequestOperationManager.h"
#import "GwForecastWeatherItem.h"
#import "GwWeather.h"
#import "GwTempModel.h"
#import "GwCurWeatherItem.h"

#import "GwCloud.h"
#import "GwMain.h"
#import "GwRain.h"

@implementation GwWeatherBi

- (void)cruSixHourRequest:(NSDictionary *)parameter
{
    
    [[AFHTTPRequestOperationManager manager] GET:ROOT_FORECAST_SIXHOUR_URL
                                      parameters:parameter
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             
                                             NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//                                             GWLog(@"cruSixHourRequest = %@",responseObject);
                                             NSArray *forecastList = [dict objectForKey:@"list"];
                                             NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:forecastList.count];
                                             
                                             if (forecastList.count > 0) {
                                                 for (NSDictionary *dict in forecastList) {
                                                     NSDictionary *main = [dict objectForKey:@"main"];
                                                     NSDictionary *weather = [[dict objectForKey:@"weather"] objectAtIndex:0];
                                                     NSDictionary *result = @{@"temp":[NSString stringWithFormat:@"%@",[main objectForKey:@"temp"]],@"icon":[weather objectForKey:@"icon"],@"dt_txt":[dict objectForKey:@"dt_txt"]};
                                                     
                                                     [resultArray addObject:result];
                                                 }
                                                 self.finishBlock(resultArray);
                                                 
                                             }else{
                                                 self.finishBlock(REQUEST_FAIL);
                                             }

                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             GWLog(@"error %@",error);
                                             self.failBlock([error description]);
                                         }];
}

- (void)curWeatherRequest:(NSDictionary *)parameter
{

    [[AFHTTPRequestOperationManager manager] GET:ROOT_CURWEATHER_URL
                                      parameters:parameter
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                             GWLog(@"cur weather obj %@ %@",[responseObject class],responseObject);
                                             NSDictionary *resultDict = (NSDictionary *)responseObject;
                                             
                                             NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:resultDict];
                                             NSDictionary *ranidict = [dict objectForKey:@"rain"];
                                             NSMutableDictionary *mutaRanindict = [NSMutableDictionary dictionaryWithDictionary:ranidict];
                                             NSInteger rain3h = [mutaRanindict[@"3h"] integerValue];
                                             [mutaRanindict setObject:[NSNumber numberWithInteger:rain3h] forKey:@"_3h"];
                                             
                                             [dict setObject:mutaRanindict forKey:@"rain"];
                                             
//                                             GWLog(@"curWeatherRequest = %@",dict);
                                             
                                             GwCurWeatherItem *curWeather = [[GwCurWeatherItem alloc] initWithDictionary:dict];
                                             
                                             self.finishBlock(curWeather);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             GWLog(@"error %@",error);
                                             self.failBlock([error description]);
                                         }];

}

- (void)forecastRequest:(NSDictionary *)parameter
{
    [[AFHTTPRequestOperationManager manager] GET:ROOT_FORECAST_URL
                                      parameters:parameter
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             GWLog(@"forecastRequest ----- %@ %@",[responseObject class],responseObject);
                                             
                                             NSDictionary *resultDict = (NSDictionary *)responseObject;
                                             NSArray *forecastList = [resultDict objectForKey:@"list"];
                                             NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:forecastList.count];
                                             
                                             if (forecastList.count > 0) {
                                                 for (NSDictionary *dict in forecastList) {
                                                        GwForecastWeatherItem *item = [[GwForecastWeatherItem alloc] initWithDictionary:dict];
                                                     [resultArray addObject:item];
                                                 }
                                                 self.finishBlock(resultArray);

                                             }else{
                                                 self.finishBlock(REQUEST_FAIL);
                                             }
                                             
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             GWLog(@"error %@",error);
                                             self.failBlock([error description]);
                                         }];
}

- (void)getForcastWeather:(GetDataFinish)successBlock
                     fail:(GetDataFail)failBlock
                 cityName:(NSString *)cityName
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityName:cityName cnt:7];
    [self forecastRequest:parameter];
}


- (void)getForcastWeather:(GetDataFinish)successBlock
                     fail:(GetDataFail)failBlock
                     ById:(NSInteger)cityId
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityID:cityId cnt:7];
    [self forecastRequest:parameter];
}

- (void)getForcastWeather:(GetDataFinish)successBlock
                     fail:(GetDataFail)failBlock
                     lon:(float)lon
                      lat:(float)lat
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityCoordinats:lon lat:lat cnt:7];
    [self forecastRequest:parameter];
}



- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock ById:(NSInteger)cityId
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityID:cityId cnt:0];
    [self curWeatherRequest:parameter];
}


- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock cityName:(NSString *)cityName
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityName:cityName cnt:0];
    [self curWeatherRequest:parameter];
}


- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock lon:(float)lon lat:(float)lat
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityCoordinats:lon lat:lat cnt:0];
    [self curWeatherRequest:parameter];
}


- (void)getForcastSixHour:(GetDataFinish)successBlock fail:(GetDataFail)failBlock lon:(NSString *)lon lat:(NSString *)lat
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityCoordinats:lon.floatValue lat:lat.floatValue cnt:1];
    [self cruSixHourRequest:parameter];
}
@end
