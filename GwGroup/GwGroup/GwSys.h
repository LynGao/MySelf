//
//  GwSys.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-17.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseModel.h"

@interface GwSys : GwBaseModel

@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,assign) NSInteger sunrise;
@property (nonatomic,assign) NSInteger sunset;
@end
