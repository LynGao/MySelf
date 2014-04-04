//
//  GwRootViewController.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-3.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwBaseViewController.h"

typedef void(^cellConfig)(id data,id cell);

@interface GwRootViewController : GwBaseViewController

@property (nonatomic, strong) cellConfig cellBlock;
@end
