//
//  GwTempView.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-4.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GwTempView : UIView

@property (nonatomic,assign) int temp;

- (id)initWithFrame:(CGRect)frame tempreture:(int)temp bigStu:(BOOL)flag;

- (void)refreshView;
@end
