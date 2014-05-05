//
//  GwMain.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-18.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"

@interface GwMain : GwBaseModel

@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) NSInteger pressure;
@property (nonatomic, assign) NSInteger temp;
@property (nonatomic, assign) float temp_max;
@property (nonatomic, assign) float temp_min;
@end
