//
//  GwMainTableViewCell.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-1.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwMainTableViewCell.h"

@implementation GwMainTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self toInit];
    }
    
    return self;
}

- (void)toInit
{
    _curStatuLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _curStatuLable.backgroundColor = [UIColor clearColor];
    _curStatuLable.font = [UIFont boldSystemFontOfSize:19];
    
    _curTempretureLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _curTempretureLable.backgroundColor = [UIColor clearColor];
    _curTempretureLable.font = [UIFont boldSystemFontOfSize:19];
    
    _todayLowestLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _todayLowestLable.backgroundColor = [UIColor clearColor];
    _todayLowestLable.font = [UIFont boldSystemFontOfSize:19];
    
    _todayHightestLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _todayHightestLable.backgroundColor = [UIColor clearColor];
    _todayHightestLable.font = [UIFont boldSystemFontOfSize:19];
    
    _stateImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_curStatuLable];
    [self.contentView addSubview:_curTempretureLable];
    [self.contentView addSubview:_todayLowestLable];
    [self.contentView addSubview:_todayHightestLable];
    [self.contentView addSubview:_stateImage];

}

- (void)layoutSubviews
{
    
}
@end
