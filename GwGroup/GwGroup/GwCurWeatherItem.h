//
//  GwCurWeatherItem.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-18.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"

@class GwCoord;
@class GwCloud;
@class GwMain;
@class GwSys;
@class GwWind;
@class GwRain;

@interface GwCurWeatherItem : GwBaseModel

@property (nonatomic, copy) NSString *base;
@property (nonatomic, strong) GwCloud *clouds;
@property (nonatomic, assign) NSInteger cod;
@property (nonatomic, strong) GwCoord *coord;
@property (nonatomic, assign) NSInteger dt;
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, strong) GwMain *main;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) GwSys *sys;
@property (nonatomic, strong) NSArray *weather;
@property (nonatomic, strong) GwWind *wind;
@property (nonatomic, strong) GwRain *rain;
@end
