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

- (void)curWeatherRequest:(NSDictionary *)parameter
{
    
//     NSDictionary *param1 = @{@"q":@"guangzhou",@"mode":@"json",@"lang":@"zh_cn",@"units":@"metric"};
    
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
                                             
                                             GWLog(@"mutaRanindict = %@",dict);
                                             
                                             GwCurWeatherItem *curWeather = [[GwCurWeatherItem alloc] initWithDictionary:dict];
                                             
                                             self.finishBlock(curWeather);
                                             
//                                             GwRain *rain = curWeather.rain;
//                                             NSLog(@"rain -- %ld",rain.all);
//                                             NSLog(@"rain -- %ld",rain._3h);
                                             
//                                             GwWeather *weather = curWeather.weather[0];
//                                             NSLog(@"---- %@",weather.description);
//                                             NSLog(@"---- %@",weather.icon);
//                                             NSLog(@"---- %@",weather.main);
//                                             NSLog(@"---- %@",weather.objectId);
//                                             
//                                             GwCloud *cloud = curWeather.clouds;
//                                             NSLog(@"---- %d",cloud.all);
//                                             
//                                             GwMain *main = curWeather.main;
//                                             NSLog(@"---- %ld",(long)main.humidity);
//                                             NSLog(@"---- %ld",main.pressure);
//                                             NSLog(@"---- %ld",main.temp);
//                                             NSLog(@"---- %@",main.temp_max);
//                                             NSLog(@"---- %@",main.temp_min);
                                             
                                             
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
//                                             GWLog(@"rsp obj %@ %@",[responseObject class],responseObject);
                                             
                                             NSDictionary *resultDict = (NSDictionary *)responseObject;
                                             NSArray *forecastList = [resultDict objectForKey:@"list"];
                                             NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:forecastList.count];
                                             
                                             if (forecastList.count > 0) {
                                                 for (NSDictionary *dict in forecastList) {
                                                        GwForecastWeatherItem *item = [[GwForecastWeatherItem alloc] initWithDictionary:dict];
                                                     [resultArray addObject:item];
                                                 }
                                                 self.finishBlock(resultArray);
                                            
//                                                 NSLog(@"tiem --- %@",item.clouds);
//                                                 NSLog(@"tiem --- %@",item.deg);
//                                                 NSLog(@"tiem --- %d",item.dt);
//                                                 NSLog(@"tiem --- %d",item.humidity);
//                                                 NSLog(@"tiem --- %@",item.pressure);
//                                                 NSLog(@"tiem --- %@",item.speed);
//                                               
//                                                
//                                                 GwWeather *w = [item.weather objectAtIndex:0];
//                                                 NSLog(@"count --- %@",[w icon]);
//                                                 NSLog(@"count --- %@",[w description]);
//                                                 NSLog(@"objectId --- %@",[w objectId]);
//                                                 NSLog(@"count --- %@",[w main]);
//                                                 
//                                                 GwTempModel *temp = item.temp;
//                                                 NSLog(@"temp --- %@",[temp day]);
                                                 
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
    NSDictionary *parameter = [GwUtil parameterCityName:cityName];
    [self forecastRequest:parameter];
}


- (void)getForcastWeather:(GetDataFinish)successBlock
                     fail:(GetDataFail)failBlock
                     ById:(NSInteger)cityId
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityID:cityId];
    [self forecastRequest:parameter];
}

- (void)getForcastWeather:(GetDataFinish)successBlock
                     fail:(GetDataFail)failBlock
                     lon:(float)lon
                      lat:(float)lat
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityCoordinats:lon lat:lat];
    [self forecastRequest:parameter];
}



- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock ById:(NSInteger)cityId
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityID:cityId];
    [self curWeatherRequest:parameter];
}


- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock cityName:(NSString *)cityName
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityName:cityName];
    [self curWeatherRequest:parameter];
}


- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock lon:(float)lon lat:(float)lat
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityCoordinats:lon lat:lat];
    [self curWeatherRequest:parameter];
}
@end
