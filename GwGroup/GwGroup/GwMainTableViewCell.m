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
    
    _todayLowestLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _todayLowestLable.backgroundColor = [UIColor clearColor];
    _todayLowestLable.font = [UIFont boldSystemFontOfSize:19];
    
    _todayHightestLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _todayHightestLable.backgroundColor = [UIColor clearColor];
    _todayHightestLable.font = [UIFont boldSystemFontOfSize:19];
    
    _stateImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _tempView = [[GwTempView alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_curStatuLable];
    [self.contentView addSubview:_curTempretureLable];
    [self.contentView addSubview:_todayLowestLable];
    [self.contentView addSubview:_todayHightestLable];
    [self.contentView addSubview:_stateImage];
    [self.contentView addSubview:_tempView];

}

- (void)layoutSubviews
{
    UIImage *image = [UIImage imageNamed:@"weather-clear"];
    CGSize imgSize = image.size;
    CGRect rect = CGRectMake((self.frame.size.width - imgSize.width) / 2 + 60, self.frame.size.height - 150, imgSize.width, imgSize.height);
    [_stateImage setImage:image];
    [_stateImage setFrame:rect];
    
    CGRect stuLabelRect = CGRectMake(_stateImage.frame.size.width + _stateImage.frame.origin.x + 5, rect.origin.y + 10, 100, 21);
    [_curStatuLable setFont:[UIFont boldSystemFontOfSize:13]];
    [_curStatuLable setBackgroundColor:[UIColor clearColor]];
    [_curStatuLable setTextColor:[UIColor whiteColor]];
    [_curStatuLable setText:_model.curStatu];
    [_curStatuLable setFrame:stuLabelRect];
    
    
    CGRect tempRect = CGRectMake(rect.origin.x - 5, stuLabelRect.origin.y + stuLabelRect.size.height + 5, 80, 70);
    [_tempView setFrame:tempRect];
    [_tempView setTemp:_model.curTempreture.intValue];
    [_tempView refreshView];
}
@end
