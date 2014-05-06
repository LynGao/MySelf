//
//  GwDailyTableViewCell.h
//  GwGroup
//
//  Created by gao wenjian on 14-5-6.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GwDailyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *weekDay;
@property (strong, nonatomic) IBOutlet UILabel *statuLabel;

@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UIImageView *icon;

@end
