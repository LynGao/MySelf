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
#import "GwUtil.h"

#import <objc/runtime.h>

@implementation GwWeatherBi

static char key;

- (void)cruSixHourRequest:(NSDictionary *)parameter
{
    
    [[AFHTTPRequestOperationManager manager] GET:ROOT_FORECAST_SIXHOUR_URL
                                      parameters:parameter
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             
                                             NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                                             GWLog(@"cruSixHourRequest = %@",responseObject);
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
//                                             GWLog(@"forecastRequest ----- %@ %@",[responseObject class],responseObject);
                                             
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


- (void)loadAllRequest:(void (^)(NSDictionary *))reult
{
    __block NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:3];
    objc_removeAssociatedObjects(self);
//    objc_setAssociatedObject(self, &key, resultDict, OBJC_ASSOCIATION_RETAIN);
    
    dispatch_queue_t _reqeustQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t _groupQueue = dispatch_group_create();
    
    
    dispatch_group_async(_groupQueue, _reqeustQueue, ^{
        GWLog(@"--- 1");
        [self getCurWeather:^(id callBackData) {
//            [resultDict setObject:@"getCurWeather finish" forKey:@"1"];
            
            NSMutableDictionary *dict = objc_getAssociatedObject(self, &key);
            [dict setObject:@"getCurWeather finish" forKey:@"1"];
            objc_setAssociatedObject(self, &key, dict, OBJC_ASSOCIATION_RETAIN);
            
        }
                       fail:^(id errorMsg) {
            
        }
                   cityName:LOCATION];
    });
    
    dispatch_group_async(_groupQueue, _reqeustQueue, ^{
                GWLog(@"--- 2");
        [self getForcastWeather:^(id callBackData) {
            NSMutableDictionary *dict = objc_getAssociatedObject(self, &key);
            [dict setObject:@"getForcastWeather finish" forKey:@"2"];
            objc_setAssociatedObject(self, &key, dict, OBJC_ASSOCIATION_RETAIN);
        }
                           fail:^(id errorMsg) {
            
        }
                       cityName:LOCATION];
    });
    
    dispatch_group_async(_groupQueue, _reqeustQueue, ^{
                GWLog(@"--- 3");
        [self getForcastSixHour:^(id callBackData) {
            NSMutableDictionary *dict = objc_getAssociatedObject(self, &key);
            [dict setObject:@"getForcastSixHour finish" forKey:@"3"];
            objc_setAssociatedObject(self, &key, dict, OBJC_ASSOCIATION_RETAIN);
        }
                           fail:^(id errorMsg) {
            
        }
                            lon:[NSUSER_DEFUALT objectForKey:LONGITU]
                            lat:[NSUSER_DEFUALT objectForKey:LATITU]];
    });
    
    dispatch_group_notify(_groupQueue, _reqeustQueue, ^{
        NSMutableDictionary *dict = objc_getAssociatedObject(self, &key);
        reult(dict);
    });

}
@end
