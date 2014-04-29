//
//  GwCurWeatherItem.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-18.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwCurWeatherItem.h"
#import "GwWeather.h"

@implementation GwCurWeatherItem

+ (Class)weather_class{
    return [GwWeather class];
}

@end
