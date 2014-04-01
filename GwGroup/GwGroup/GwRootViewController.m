//
//  GwRootViewController.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-1.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwRootViewController.h"
#import "GwTableDataSource.h"
#import "GwMainTableViewCell.h"

@interface GwRootViewController ()<UITableViewDelegate>
{
    UITableView *_mainTable;
    
    GwTableDataSource *_dataSouce;
}
@end

@implementation GwRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GWLog(@"-----");
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    [_mainTable setDelegate:self];
    
    NSArray *data = @[@"1",@"2",@"3"];
    _dataSouce = [[GwTableDataSource alloc] initWithData:(NSMutableArray *)data
                                             headerTitle:nil
                                               cellClass:@"GwMainTableViewCell"
                                                 identiy:@"MainCell"
                                             configBlock:^(id cell, id data) {
                                                 GwMainTableViewCell *cells = (GwMainTableViewCell *)cell;
                                                 [cells.showTextLabel setText:data];
                                            }];
    [_mainTable setDataSource:_dataSouce];
    [_mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mainTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
