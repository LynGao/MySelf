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
#import "GwCurWeatherItem.h"
#import "GwMain.h"
#import "SVPullToRefresh.h"
#import "GwSixTableViewCell.h"
#import "UIImageView+GwImageView.h"

@interface GwRootViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTable;
    UIImageView *_bgImage;
    
    NSInteger _requestCount;
    
    NSMutableDictionary *_curWeatherDict;
    
    __block GwCurWeatherItem *curWeatherItem;
}
@property (nonatomic, strong) NSMutableArray *forecastArray;
@property (nonatomic, strong) NSMutableArray *sixHourForecastArray;

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:LOCATION_NOTIF_NAME object:nil];
    
 

    [self configBlock];
    
//    _bgImage = [[UIImageView alloc] initWithFrame:self.view.frame];
//    [_bgImage setImage:[UIImage imageNamed:@"bg"]];
//    [self.view addSubview:_bgImage];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [_mainTable setBackgroundColor:[UIColor clearColor]];
    [_mainTable setDataSource:self];
    [_mainTable setDelegate:self];
//    [_mainTable setPagingEnabled:YES];
    [self.view addSubview:_mainTable];
    
    __weak GwRootViewController *weakSelf = self;
    [_mainTable addPullToRefreshWithActionHandler:^{
        
        if (LOCATION == nil) {
            
        }else{
            [weakSelf startRequest];
        }
        
        
    }];
    
    [_mainTable triggerPullToRefresh];
    
   
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
        static NSString *identify = @"GwMainTableViewCell";
        GwMainTableViewCell *cell = (GwMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[GwMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        if (curWeatherItem) {
            self.cellBlock(curWeatherItem,cell);
        }
        
        return cell;
    }else  if (indexPath.row > 0 && indexPath.row < 9){
        static NSString *identify = @"ForcastSix";
        GwSixTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GwSixTableViewCell" owner:nil options:nil] lastObject];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        [self cofigCell:cell indexPath:indexPath];
    
        return cell;
    }else{
        static NSString *identify = @"norlmal";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        return cell;
    }
}

#pragma mark -- scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat offset = MAX(scrollView.contentOffset.y, 0);
    CGFloat hight = scrollView.bounds.size.height;
    CGFloat percent = MIN(offset / hight, 1);
//    [_bgImage setImageToBlur:[UIImage imageNamed:@"bg"] blurRadius:percent completionBlock:^{
//        
//    }];
}


#pragma mark -- 配置cell blcok
- (void)configBlock
{
    self.cellBlock = ^(id data,id cell){
        
        if ([data isKindOfClass:[GwForecastWeatherItem class]]) {
            GwForecastWeatherItem *item = (GwForecastWeatherItem *)data;
            GwWeather *weather = [item.weather objectAtIndex:0];
            GwTempModel *temp = item.temp;
        
            GwMainCellModel *model = [[GwMainCellModel alloc] init];
            model.cityName = LOCATION;
            model.curStatu = weather.description;
            model.curTempreture = temp.day;
            model.statuImgName = weather.icon;
            model.dt = item.dt;
            
            [cell setModel:model];
            
        }else if([data isKindOfClass:[GwCurWeatherItem class]]){
            
            GwCurWeatherItem *item = (GwCurWeatherItem *)data;
            GwWeather *weather = [item.weather objectAtIndex:0];
            GwMain *main = item.main;
            
            GwMainCellModel *model = [[GwMainCellModel alloc] init];
            model.cityName = LOCATION;
            model.curStatu = weather.description;
            model.curTempreture = [NSString stringWithFormat:@"%ld",(long)main.temp];
            model.statuImgName = weather.icon;
            model.dt = item.dt;
            model.todayHightestTemp = [NSString stringWithFormat:@"%.2f",main.temp_max];
            model.todayLowestTemp = [NSString stringWithFormat:@"%.2f",main.temp_min];
            model.humidity = main.humidity;

            [cell setModel:model];
            
          
        }
    };
}

//
- (void)cofigCell:(GwSixTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
//    NSString stringWithFormat:@"%0"
    [cell.tempretureLabel setText:[self.sixHourForecastArray[indexPath.row - 1] objectForKey:@"temp"]];
    [cell.statuImage setGwImageWithUrl:[NSString stringWithFormat:@"%@/%@",WEAHTER_STATU_IMAGE_URL,[self.sixHourForecastArray[indexPath.row - 1] objectForKey:@"icon"]]
                         BaseImageName:nil
                        IndicatorStyle:UIActivityIndicatorViewStyleGray];
}


#pragma mark -- location delegate
- (void)locationSuccess
{
    [self startRequest];
}

#pragma mark -- load weather info
- (void)startRequest
{
    [self curWeather];
    [self forcastSixHour];
    [self forecastDayliy];
}

- (void)forecastDayliy
{
     __weak GwRootViewController *weakSelf = self;

    GwWeatherBi *bi = [[GwWeatherBi alloc] init];
    
    [bi getForcastWeather:^(id callBackData) {
        
        NSArray *array = (NSArray *)callBackData;
        self.forecastArray = [NSMutableArray arrayWithArray:array];
        
        [weakSelf completeCacu];
        
    } fail:^(id errorMsg) {
        
        [weakSelf completeCacu];
        
    } cityName:LOCATION];
}


- (void)curWeather
{
    __weak GwRootViewController *weakSelf = self;
    
    GwWeatherBi *bi = [[GwWeatherBi alloc] init];
    
    [bi getCurWeather:^(id callBackData) {
        
         curWeatherItem = callBackData;
        
         [weakSelf completeCacu];
        
    } fail:^(id errorMsg) {
        
         [weakSelf completeCacu];
        
    } cityName:LOCATION];
}

- (void)forcastSixHour
{
    __weak GwRootViewController *weakSelf = self;
    
    GwWeatherBi *bi = [[GwWeatherBi alloc] init];
    
    [bi getForcastSixHour:^(id callBackData) {
        
                self.sixHourForecastArray = [NSMutableArray arrayWithArray:callBackData];
                [weakSelf completeCacu];
        }
                      fail:^(id errorMsg) {
                          [weakSelf completeCacu];
        }
                      lon:[[NSUserDefaults standardUserDefaults] objectForKey:LONGITU]
                      lat:[[NSUserDefaults standardUserDefaults] objectForKey:LATITU]];
}

- (void)completeCacu
{
    _requestCount++;
    if (_requestCount == 2) {
        _requestCount = 0;
        
        [_mainTable.pullToRefreshView stopAnimating];
        
        [_mainTable reloadData];
        
        return;
    }
        
}
@end
