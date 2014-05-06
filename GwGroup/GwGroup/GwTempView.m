//
//  GwTempView.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-4.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwTempView.h"
#import <CoreText/CoreText.h>
@interface GwTempView()
{
    UILabel *_tempLabel;
    UILabel *_zero;
}

@end
@implementation GwTempView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self intialView:0 zeroSize:0];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         [self intialView:0 zeroSize:0];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame tempSize:(int)tempSize zeroSize:(int)zeroSize
{
    self = [super initWithFrame:frame];
    if (self) {
        [self intialView:tempSize zeroSize:zeroSize];
    }
    return self;
}

- (void)intialView:(int)tempSize zeroSize:(int)zeroSize
{
    [self setBackgroundColor:[UIColor clearColor]];
    _tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 70)];
    [_tempLabel setText:[NSString stringWithFormat:@"%d",_temp]];
    [_tempLabel setBackgroundColor:[UIColor clearColor]];
    [_tempLabel setTextColor:[UIColor whiteColor]];
    [_tempLabel setTextAlignment:NSTextAlignmentCenter];
    [_tempLabel setFont:[UIFont fontWithName:@"Times New Roman" size:tempSize]];
    
    _zero = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_tempLabel.frame) + _tempLabel.frame.origin.x, _tempLabel.frame.origin.y, 20, 20)];
    [_zero setText:@"o"];
    [_zero setBackgroundColor:[UIColor clearColor]];
    [_zero setTextColor:[UIColor whiteColor]];
    [_zero setFont:[UIFont fontWithName:@"Times New Roman" size:zeroSize]];
    
    [self addSubview:_tempLabel];
    [self addSubview:_zero];

}


- (void)refreshView:(int)tempSize zeroSize:(int)zeroSize
{
    if (tempSize > 0) {
         [_tempLabel setFont:[UIFont fontWithName:@"Times New Roman" size:tempSize]];
        [_zero setFont:[UIFont fontWithName:@"Times New Roman" size:zeroSize]];
    }
    
    [_tempLabel setText:[NSString stringWithFormat:@"%d",_temp]];
}


//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    NSString *targ = [NSString stringWithFormat:@"%d",_temp];
//
//    NSMutableAttributedString *attrbu = [[NSMutableAttributedString alloc] initWithString:targ];
//    [attrbu addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor whiteColor].CGColor range:NSMakeRange(0, targ.length)];
//    
//    [attrbu addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont fontWithName:@"Times New Roman" size:80].fontName, 80, NULL)) range:NSMakeRange(0, targ.length)];
//    
//    //o
////    [attrbu addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont fontWithName:@"Times New Roman" size:20].fontName, 20, NULL)) range:NSMakeRange(targ.length-1, 1)];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //移动当前画布
////    CGContextTranslateCTM(context, 0, -10);
//    
//    CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
//    
//    CTFramesetterRef sets = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrbu);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, rect);
//    
//    CTFrameRef frame = CTFramesetterCreateFrame(sets, CFRangeMake(0, 0), path, NULL);
//    CFRelease(path);
//    CFRelease(sets);
//    
//    CTFrameDraw(frame, context);
//    
//    CFRelease(frame);
//}
@end
