//
//  GwWeather.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-8.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "Jastor.h"

@interface GwWeather : Jastor

@property (nonatomic, strong) NSDictionary *coord;
@property (nonatomic, strong) NSDictionary *sys;
@property (nonatomic, strong) NSArray *weather;
@property (nonatomic, strong) NSString *base;
@property (nonatomic, strong) NSDictionary *main;
@property (nonatomic, strong) NSDictionary *wind;
@property (nonatomic, strong) NSDictionary *clouds;
@property (nonatomic, strong) NSString *dt;
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cod;
@end
