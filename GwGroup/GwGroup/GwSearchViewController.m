//
//  GwSearchViewController.m
//  GwGroup
//
//  Created by gao wenjian on 14-5-9.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwSearchViewController.h"
#import "GwUtil.h"

@interface GwSearchViewController ()<UISearchBarDelegate>
{
   IBOutlet UISearchBar *_searchBar;
}
@end

@implementation GwSearchViewController

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
    
    self.navigationItem.title = @"search";
    
    [_searchBar setDelegate:self];
    [self createCityList];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}

#pragma mark -- city tips
- (void)createCityList
{
    NSDictionary *dict = [GwUtil loadPlistFromBundle:@"CityList" type:@"plist"];
    NSArray *array = dict[@"City"];
    GWLog(@"arrat - %@",array);
    CGFloat y = 20 + 44;
    int count = 0;
    for (int i = 0; i < array.count; i++)
    {
        if (i % 3 == 0) {
            y+=10 + 21;
            count = 0;
        }else{
            count++;
        }
        CGRect frame = CGRectMake(20 * (count + 1) + (60 * count), y, 60, 21);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setFrame:frame];
        [btn addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

    }
}

- (void)cityClick:(UIButton *)btn
{
    
}

#pragma mark -- searchbar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

@end
