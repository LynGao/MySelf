//
//  GwWind.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-17.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"

@interface GwWind : GwBaseModel

@property (nonatomic, assign) NSInteger deg;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) NSInteger var_beg;
@property (nonatomic, assign) NSInteger var_end;
@end
