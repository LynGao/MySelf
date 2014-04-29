//
//  UIImageView+GwImageView.m
//  BlockTest
//
//  Created by gao wenjian on 13-7-31.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import "UIImageView+GwImageView.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>

static char INDICATOR_ASS_KEY;

@interface UIImageView(private)

- (void)createIndicatorView;
@end

@implementation UIImageView (GwImageView)

@dynamic indicatorView;

- (void)createIndicatorView:(UIActivityIndicatorViewStyle)style
{
    if (![self indicatorView]) {
        self.indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style] autorelease];
        CGSize size = self.indicatorView.frame.size;
//        [self.indicatorView setCenter:CGPointMake(self.frame.size.width / 2 - size.width / 2, self.frame.size.height / 2 - size.height / 2)];
        [self.indicatorView setFrame:CGRectMake(self.frame.size.width / 2 - size.width / 2, self.frame.size.height / 2 - size.height / 2, size.width, size.height)];
        [self.indicatorView setHidesWhenStopped:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubview:self.indicatorView];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView startAnimating];
    });
}

- (void)removeIndicator
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.indicatorView) {
            [self.indicatorView stopAnimating];
            [self.indicatorView removeFromSuperview];
            self.indicatorView = nil;
        }
//    });
}

//set association
- (void)setIndicatorView:(UIActivityIndicatorView *)indicatorView
{
    objc_setAssociatedObject(self, &INDICATOR_ASS_KEY, indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)indicatorView
{
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &INDICATOR_ASS_KEY);
}

- (void)setGwImageWithUrl:(NSString *)url BaseImageName:(NSString *)imageName IndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    [self createIndicatorView:style];
    
    [self setGwImageWithUrl:url BaseImageName:imageName];
}


-(void)setGwImageWithUrl:(NSString *)url BaseImageName:(NSString *)imageName
{
    if (imageName != nil) {
        self.image = [UIImage imageNamed:imageName];
    }
    
    GwImageManager *manager = [GwImageManager shareInstance];
    
//    [manager cancleCurDownLoader:url withDelegate:self];
    
    //1.check out cache
    if (url)
    {
        [manager gwManagerStartDownloadWithUrl:url
                                  withDelegate:self
                               isNeedToShowHud:NO
                                   cacheEnable:YES];
    }
}

#pragma mark - gwManager delegate
-(void)gwManagerDidfindImageData:(NSData *)data
{
    [self removeIndicator];
    
    if (data) {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        CFRelease(imageSource);
        self.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
}

- (void)gwManagerDidNotFindImageData
{

    [self removeIndicator];
}

- (void)gwManagerProcessCallBack:(float)percent
{
    //do nothing
    if (percent<1.0) {
        
    }else{
        
    }
}

@end
