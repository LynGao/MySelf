//
//  GwTableDataSource.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-1.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ConfigCellBlock)(id cell,id data);

@interface GwTableDataSource : NSObject<UITableViewDataSource>

/**
 *  表头
 */
@property (nonatomic, strong) NSMutableArray *headerTitleArray;

/**
 *  列表数据源
 */
@property (nonatomic, strong) NSMutableArray *dataItemArray;

@property (nonatomic, strong) ConfigCellBlock confiCell;

@property (nonatomic, strong) NSString *cellClassName;

- (id)initWithData:(NSMutableArray *)array
         headerTitle:(NSMutableArray *)header
           cellClass:(NSString *)className
            identiy:(NSString *)indetify
         configBlock:(ConfigCellBlock)block;

@end
