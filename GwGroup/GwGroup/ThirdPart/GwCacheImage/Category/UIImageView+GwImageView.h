//
//  UIImageView+GwImageView.h
//  BlockTest
//
//  Created by gao wenjian on 13-7-31.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GwImageManager.h"

@interface UIImageView (GwImageView)<GwImageManagerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

/**
    下载图片，带cache
    @param url 图片地址 
    @param imageName 缩略图片
*/
-(void)setGwImageWithUrl:(NSString *)url
           BaseImageName:(NSString *)imageName;

/**
 *  下载图片，带菊花loading
 *
 *  @param url       图片地址
 *  @param imageName 默认图片名字
 *  @param style     转圈的样式
 */
- (void)setGwImageWithUrl:(NSString *)url
            BaseImageName:(NSString *)imageName
           IndicatorStyle:(UIActivityIndicatorViewStyle)style;
@end
