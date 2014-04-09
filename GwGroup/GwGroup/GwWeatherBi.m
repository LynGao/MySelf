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
@implementation GwWeatherBi

- (void)BaseRequest:(NSDictionary *)parameter
{
    [[AFHTTPRequestOperationManager manager] GET:ROOT_FORECAST_URL
                                      parameters:parameter
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             GWLog(@"rsp obj %@ %@",[responseObject class],responseObject);
                                             
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
    [self BaseRequest:parameter];
}


- (void)getForcastWeather:(GetDataFinish)successBlock
                     fail:(GetDataFail)failBlock
                     ById:(NSInteger)cityId
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityID:cityId];
    [self BaseRequest:parameter];
}

- (void)getForcastWeather:(GetDataFinish)successBlock
                     fail:(GetDataFail)failBlock
                     lon:(float)lon
                      lat:(float)lat
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityCoordinats:lon lat:lat];
    [self BaseRequest:parameter];
}



- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock ById:(NSInteger)cityId
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityID:cityId];
    [self BaseRequest:parameter];
}


- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock cityName:(NSString *)cityName
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityName:cityName];
    [self BaseRequest:parameter];
}


- (void)getCurWeather:(GetDataFinish)successBlock fail:(GetDataFail)failBlock lon:(float)lon lat:(float)lat
{
    self.finishBlock = successBlock;
    self.failBlock = failBlock;
    NSDictionary *parameter = [GwUtil parameterCityCoordinats:lon lat:lat];
    [self BaseRequest:parameter];
}
@end
