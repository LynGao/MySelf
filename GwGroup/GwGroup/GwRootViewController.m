//
//  GwRootViewController.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-3.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwRootViewController.h"
#import "UIImageView+LBBlurredImage.h"
@interface GwRootViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTable;
    UIImageView *_bgImage;
}

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
    
    _bgImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_bgImage setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:_bgImage];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [_mainTable setBackgroundColor:[UIColor clearColor]];
    [_mainTable setDataSource:self];
    [_mainTable setDelegate:self];
    [_mainTable setPagingEnabled:YES];
    [self.view addSubview:_mainTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
     [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
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

@end
