//
//  GwTempModel.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-9.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"

@interface GwTempModel : GwBaseModel

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *eve;
@property (nonatomic, strong) NSString *max;
@property (nonatomic, strong) NSString *min;
@property (nonatomic, strong) NSString *morn;
@property (nonatomic, strong) NSString *night;
@end
