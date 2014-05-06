//
//  GwTableDataSource.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-1.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwTableDataSource.h"

#import "GwMainTableViewCell.h"

@interface GwTableDataSource()

@property (nonatomic, strong) NSString *indentify;

@end

@implementation GwTableDataSource

#pragma mark --

- (id)initWithData:(NSMutableArray *)array
         headerTitle:(NSMutableArray *)header
           cellClass:(NSString *)className
           identiy:(NSString *)indetify
       configBlock:(ConfigCellBlock)block
{
    self = [super init];
    if (self) {
        self.indentify = indetify;
        self.dataItemArray = array;
        self.headerTitleArray = header;
        self.cellClassName = className;
        self.confiCell = block;
    }
    return self;
}

#pragma mark -- tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataItemArray) {
        return _dataItemArray.count;
    }else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.indentify];
    if (!cell) {
        if (_cellClassName) {
            GWLog(@"_____ reuse ----");
            [tableView registerNib:[UINib nibWithNibName:_cellClassName bundle:nil] forCellReuseIdentifier:self.indentify];
            cell = [[[NSBundle mainBundle] loadNibNamed:_cellClassName owner:nil options:nil] lastObject];
            [cell setBackgroundColor:[UIColor clearColor]];
    
        }else{
            GWLog(@"____ norm resue ----");
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"normal"];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    self.confiCell(cell,_dataItemArray[indexPath.row],indexPath.row);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_headerTitleArray) {
        return _headerTitleArray[section];
    }else
        return nil;
}

@end
