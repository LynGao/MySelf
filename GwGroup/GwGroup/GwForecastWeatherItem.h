//
//  GwWeather.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-8.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"
#import "GwTempModel.h"
#import "GwCloud.h"
#import "GwWind.h"
#import "GwRain.h"
//#import "GwMain.m"

@interface GwForecastWeatherItem : GwBaseModel

//@property (nonatomic, strong) NSString *clouds0;
@property (nonatomic, strong) NSString *deg;
@property (nonatomic, assign) NSInteger dt;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, strong) NSString *pressure;
@property (nonatomic, strong) NSString *speed;
//@property (nonatomic, strong) NSDictionary *temp;
@property (nonatomic, strong) GwTempModel *temp;
@property (nonatomic, strong) NSArray *weather;

//add for six hour
@property (nonatomic, strong) GwCloud *clouds;
@property (nonatomic, strong) GwWind *wind;
@property (nonatomic, strong) GwRain *rain;
@property (nonatomic, strong) NSString *dt_text;
//@property (nonatomic, strong) GwMain *main;


@end
