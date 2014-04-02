//
//  GwRootTableViewDelegate.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-2.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwRootTableViewDelegate.h"

@implementation GwRootTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }else if(indexPath.row == 1){
        return 60;
    }else
        return 40;
}

@end
