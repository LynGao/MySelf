//
//  GwStateImage.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-2.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwStateImage.h"

@interface GwStateImage()
{

}
@property (nonatomic, strong) NSString *imageName;
@end

@implementation GwStateImage

- (id)initWithFrame:(CGRect)frame WithStateType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.imageName = @"weather-few-night";
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:self.imageName];
    [image drawAtPoint:CGPointMake(0, 0)];
}


@end
