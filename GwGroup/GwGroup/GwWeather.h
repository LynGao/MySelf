//
//  GwWeather.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-9.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"

/**
 *  json 字段与 对象字段要保持一致。如 json:{"clouds":55} ----> modle: GwCloud clouds; clouds要相等
 */
@interface GwWeather : GwBaseModel



@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *objectId;//id类型的，需要生命为 string 且命名 必须是 objectId
@property (nonatomic, strong) NSString *main;
@end
