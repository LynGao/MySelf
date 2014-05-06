//
//  GwMainTableViewCell.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-1.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwMainTableViewCell.h"
#import "UIImageView+GwImageView.h"
#import "GwUtil.h"

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
    
    _cityName = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width,35)];
    _cityName.backgroundColor = [UIColor clearColor];
    _cityName.font = [UIFont boldSystemFontOfSize:30];
    [_cityName setTextColor:[UIColor whiteColor]];
    [_cityName setTextAlignment:NSTextAlignmentCenter];
    
    //time label
   
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _cityName.frame.origin.y + _cityName.frame.size.height + 1, self.frame.size.width, 21)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont boldSystemFontOfSize:15];
    [_timeLabel setTextColor:[UIColor whiteColor]];
    [_timeLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_timeLabel];
    
    _curStatuLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _curStatuLable.backgroundColor = [UIColor clearColor];
    _curStatuLable.font = [UIFont boldSystemFontOfSize:19];
    
    _todayLowestLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _todayLowestLable.backgroundColor = [UIColor clearColor];
    [_todayLowestLable setTextColor:[UIColor whiteColor]];
    _todayLowestLable.font = [UIFont boldSystemFontOfSize:13];
    
    _todayHightestLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _todayHightestLable.backgroundColor = [UIColor clearColor];
    [_todayHightestLable setTextColor:[UIColor whiteColor]];
    _todayHightestLable.font = [UIFont boldSystemFontOfSize:13];
    
    _humidityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _humidityLabel.backgroundColor = [UIColor clearColor];
    [_humidityLabel setTextColor:[UIColor whiteColor]];
    _humidityLabel.font = [UIFont boldSystemFontOfSize:13];
    
    _windLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _windLabel.backgroundColor = [UIColor clearColor];
    [_windLabel setTextColor:[UIColor whiteColor]];
    _windLabel.font = [UIFont boldSystemFontOfSize:13];
    
    _stateImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _tempView = [[GwTempView alloc] initWithFrame:CGRectZero
                                         tempSize:80
                                         zeroSize:20];

    [self.contentView addSubview:_cityName];
    [self.contentView addSubview:_curStatuLable];
    [self.contentView addSubview:_curTempretureLable];
    [self.contentView addSubview:_todayLowestLable];
    [self.contentView addSubview:_todayHightestLable];
    [self.contentView addSubview:_stateImage];
    [self.contentView addSubview:_tempView];
    [self.contentView addSubview:_humidityLabel];

}

- (void)layoutSubviews
{
    //state
    CGRect rect = CGRectMake((self.frame.size.width - 50) / 2 + 60, self.frame.size.height - 150, 50, 50);
    [_stateImage setGwImageWithUrl:[NSString stringWithFormat:@"%@/%@",WEAHTER_STATU_IMAGE_URL,_model.statuImgName]
                     BaseImageName:@"weather-clear"
                    IndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_stateImage setFrame:rect];
    
    
    //statu
    CGRect stuLabelRect = CGRectMake(_stateImage.frame.size.width + _stateImage.frame.origin.x + 5, rect.origin.y + 10, 100, 21);
    [_curStatuLable setFont:[UIFont boldSystemFontOfSize:13]];
    [_curStatuLable setBackgroundColor:[UIColor clearColor]];
    [_curStatuLable setTextColor:[UIColor whiteColor]];
    [_curStatuLable setText:_model.curStatu];
    [_curStatuLable setFrame:stuLabelRect];
    
    //temp
    CGRect tempRect = CGRectMake(rect.origin.x - 5, stuLabelRect.origin.y + stuLabelRect.size.height + 5, 80, 70);
    [_tempView setFrame:tempRect];
    [_tempView setTemp:_model.curTempreture.intValue];
    [_tempView refreshView:0 zeroSize:0];
    
    //city
    [_cityName setText:_model.cityName];
    
    //time
    NSString *refreshTime = [GwUtil formatGMT:_model.dt];
    [_timeLabel setText:refreshTime];
    
    //today low & hight
    [_todayLowestLable setFrame:CGRectMake(tempRect.origin.x, tempRect.origin.y + tempRect.size.height + 2, 50, 21)];
    [_todayLowestLable setText:[NSString stringWithFormat:@"L:%@",_model.todayLowestTemp]];
    [_todayHightestLable setFrame:CGRectMake(_todayLowestLable.frame.origin.x + _todayLowestLable.frame.size.width + 10, _todayLowestLable.frame.origin.y, 50, 21)];
    [_todayHightestLable setText:[NSString stringWithFormat:@"H:%@",_model.todayHightestTemp]];
    
    //humidity
    [_humidityLabel setFrame:CGRectMake(_todayLowestLable.frame.origin.x - 60, _todayLowestLable.frame.origin.y, 60, 21)];
    [_humidityLabel setText:[NSString stringWithFormat:@"湿度:%ld",(long)_model.humidity]];
    
}
@end
