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

#import "GwStateImage.h"
#import "GwRootTableViewDelegate.h"

@interface GwRootViewController ()
{
    UITableView *_mainTable;
    
    GwTableDataSource *_dataSouce;
    GwRootTableViewDelegate *_delegate;
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
    
    _delegate = [[GwRootTableViewDelegate alloc] init];
    [_mainTable setDelegate:_delegate];
    
    __weak GwRootViewController *weakSelf = self;
    NSArray *data = @[@"1",@"2",@"3"];
    _dataSouce = [[GwTableDataSource alloc] initWithData:(NSMutableArray *)data
                                             headerTitle:nil
                                               cellClass:@"GwMainTableViewCell"
                                                 identiy:@"MainCell"
                                             configBlock:^(id cell, id data ,NSInteger index) {
                                                 [weakSelf configCell:cell
                                                                 data:data
                                                                index:index];
                                            }];
    [_mainTable setDataSource:_dataSouce];
    [_mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mainTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any
    that can be recreated.
}


- (void)configCell:(id)cell
              data:(id)data
             index:(NSInteger)index
{
    GwMainTableViewCell *cells = (GwMainTableViewCell *)cell;
    if (index == 0) {
        GwStateImage *stat = [[GwStateImage alloc] initWithFrame:CGRectMake(20, 20, 50, 50) WithStateType:0];
        [cells.contentView addSubview:stat];
    }else
        [cells.showTextLabel setText:data];
}

#pragma mark -- table delegate

@end
