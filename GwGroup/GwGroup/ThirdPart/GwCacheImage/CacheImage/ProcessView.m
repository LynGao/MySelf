//
//  ProcessView.m
//  BlockTest
//
//  Created by gao wenjian on 13-9-29.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import "ProcessView.h"
#import "Constant.h"

@interface ProcessView()
{
    float _process;
}
@end

@implementation ProcessView


- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
      self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGPoint centerPoint = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = rect.size.width / 2; //半径
    CGFloat progress = MIN(_process, 1.0f - FLT_EPSILON);
    CGFloat radians = (progress * 2.0f * M_PI) - M_PI_2;//弧度

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_process > 0 && _process <= 1.0) {
        
        CGFloat cycleRadians =  (1.0f - FLT_EPSILON) * 2.0f * M_PI - M_PI_2;
    
        //画一个半透明的圆(背景)
        CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:0.7] CGColor]);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, 3.0f * M_PI_2, cycleRadians,NO);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
        
        //轨道
        CGContextSetRGBStrokeColor(context,0,0,0,0.9);//画笔线的颜色
        CGContextSetLineWidth(context, PROCESSVIEW_LINER_WIDTH);
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius - 10, 3.0f * M_PI_2, cycleRadians, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        //进度
        CGContextSetRGBStrokeColor(context,PROCESSVIEW_CICLE_COLOR_R / 255.0,PROCESSVIEW_CICLE_COLOR_G / 255.0,PROCESSVIEW_CICLE_COLOR_G / 255.0,1.0);//画笔线的颜色
        CGContextSetLineWidth(context, PROCESSVIEW_LINER_WIDTH);
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius - 10, 3.0f * M_PI_2, radians, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)setProcess:(float)process
{
    _process = process;
}
@end
