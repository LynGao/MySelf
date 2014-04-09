//
//  GwRootViewController.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-3.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwRootViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "GwMainTableViewCell.h"
#import "GwMainCellModel.h"

#import "GwWeatherBi.h"
#import "GwForecastWeatherItem.h"
#import "GwWeather.h"

@interface GwRootViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTable;
    UIImageView *_bgImage;
}
@property (nonatomic, strong) NSMutableArray *forecastArray;
@end

@implementation GwRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GwUtil formatGMT:1397016000];

    [self configBlock];
    
    _bgImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_bgImage setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:_bgImage];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [_mainTable setBackgroundColor:[UIColor clearColor]];
    [_mainTable setDataSource:self];
    [_mainTable setDelegate:self];
    [_mainTable setPagingEnabled:YES];
    [self.view addSubview:_mainTable];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getForecast];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.view.bounds.size.height;
    }else{
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identify = @"first";
        GwMainTableViewCell *cell = (GwMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[GwMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        if (_forecastArray.count > 0) {
            self.cellBlock(_forecastArray[0],cell);
        }
        
        
        return cell;
    }else{
        static NSString *identify = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        
        
        return cell;
    }
    
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   }

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat offset = MAX(scrollView.contentOffset.y, 0);
    CGFloat hight = scrollView.bounds.size.height;
    CGFloat percent = MIN(offset / hight, 1);
    [_bgImage setImageToBlur:[UIImage imageNamed:@"bg"] blurRadius:percent completionBlock:^{
        
    }];

}

/**
 *  配置blcok
 */
- (void)configBlock
{
    self.cellBlock = ^(id data,id cell){
        
        if ([data isKindOfClass:[GwForecastWeatherItem class]]) {
            GwForecastWeatherItem *item = (GwForecastWeatherItem *)data;
            GwWeather *weather = [item.weather objectAtIndex:0];
            GwTempModel *temp = item.temp;
            
            GwMainCellModel *model = [[GwMainCellModel alloc] init];
            model.cityName = @"深圳市";
            model.curStatu = weather.description;
            model.curTempreture = temp.day;
            model.statuImgName = weather.icon;
            [cell setModel:model];
            
        }else{
            GwMainCellModel *model = [[GwMainCellModel alloc] init];
            model.cityName = @"深圳市";
            //        model.curStatu = @"多云";
            //        model.curTempreture = @"23";
            model.statuImgName = @"weather-clear";
            [cell setModel:model];
        }
        
    };

}

- (void)getForecast
{
    GwWeatherBi *bi = [[GwWeatherBi alloc] init];
    
    NSString *urlString = @"guangzhou";

    [bi getForcastWeather:^(id callBackData) {
        NSArray *array = (NSArray *)callBackData;
        self.forecastArray = [NSMutableArray arrayWithArray:array];
        [_mainTable reloadData];
    } fail:^(id errorMsg) {
        
    } cityName:urlString];
}
@end
