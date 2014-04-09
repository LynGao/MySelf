//
//  GwWeather.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-8.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"
#import "GwTempModel.h"
@interface GwForecastWeatherItem : GwBaseModel

//@property (nonatomic, strong) NSDictionary *coord;
//@property (nonatomic, strong) NSDictionary *sys;
//@property (nonatomic, strong) NSArray *weather;
//@property (nonatomic, strong) NSString *base;
//@property (nonatomic, strong) NSDictionary *main;
//@property (nonatomic, strong) NSDictionary *wind;
//@property (nonatomic, strong) NSDictionary *clouds;
//@property (nonatomic, strong) NSString *dt;
//@property (nonatomic, strong) NSString *_id;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *cod;

@property (nonatomic, strong) NSString *clouds;
@property (nonatomic, strong) NSString *deg;
@property (nonatomic, assign) NSInteger dt;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, strong) NSString *pressure;
@property (nonatomic, strong) NSString *speed;
//@property (nonatomic, strong) NSDictionary *temp;
@property (nonatomic, strong) GwTempModel *temp;
@property (nonatomic, strong) NSArray *weather;
@end
