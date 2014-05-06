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

//@property (nonatomic,assign) int tempSize;
//@property (nonatomic,assign) int zeroSize;

- (id)initWithFrame:(CGRect)frame tempSize:(int)tempSize zeroSize:(int)zeroSize;

- (void)refreshView:(int)tempSize zeroSize:(int)zeroSize;
@end
