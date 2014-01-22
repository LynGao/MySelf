//
//  GwCityCode.h
//  GwGroup
//
//  Created by gao wenjian on 14-1-21.
//  Copyright (c) 2014年 gao wenjian. All rights reserved.
//

#import "GwBaseModel.h"

@interface GwCityCode : GwBaseModel
{
    NSString *woeId;
    NSString *iso;
    NSString *name;
    NSString *language;
    NSString *placetype;
    NSString *parentId;
}

@property (nonatomic,copy) NSString *woeId;
@property (nonatomic,copy) NSString *iso;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *language;
@property (nonatomic,copy) NSString *placetype;
@property (nonatomic,copy) NSString *parentId;
@end
