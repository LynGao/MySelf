//
//  GwWeather.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-9.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"

@interface GwWeather : GwBaseModel

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *objectId;//id类型的，需要生命为 string 且命名 必须是 objectId
@property (nonatomic, strong) NSString *main;
@end
