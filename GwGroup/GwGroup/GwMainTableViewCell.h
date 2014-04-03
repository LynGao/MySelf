//
//  GwMainTableViewCell.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-1.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GwMainCellModel.h"
#import "GwStateImage.h"

@interface GwMainTableViewCell : UITableViewCell

@property (nonatomic, strong) GwMainCellModel *model;
@property (nonatomic, strong) UILabel *curStatuLable;
@property (nonatomic, strong) UILabel *curTempretureLable;
@property (nonatomic, strong) UILabel *todayLowestLable;
@property (nonatomic, strong) UILabel *todayHightestLable;
@property (nonatomic, strong) UIImageView *stateImage;
@end
