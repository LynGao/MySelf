//
//  PictureScrollAuto.h
//  Tibet5100
//
//  Created by gao wenjian on 13-4-15.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+GwImageView.h"
#import "BaseImageView.h"

@protocol PictureScrollAutoTapDelegate <NSObject>

-(void)pictureHasTap:(NSInteger)index UrlString:(NSString *)url;

@end

@interface PictureScrollAuto : UIView<UIScrollViewDelegate>{
    NSObject<PictureScrollAutoTapDelegate> *_delegate;
}
@property (nonatomic, assign) NSObject<PictureScrollAutoTapDelegate> *delegate;

/**
 *  是否能够循环滑动
 */
@property (nonatomic, assign) BOOL canCycle;

@property (nonatomic, assign) BOOL autoPlay;

- (void)rebuildTimer:(BOOL)flag;

/**
    初始化。用于跑马灯类的图片播放。此类暂不提供自动播放
    @param loadingFlag 是否显示加载
    @param cacheFlag 是否本地缓存,只会内存缓存
 */
- (id)initWithFrame:(CGRect)frame
           urlArray:(NSMutableArray *)urlArray
   placeholderImage:(NSString *)placehol
        loadingFlag:(BOOL)loadingFlag
          cacheFlag:(BOOL)cacheFlag;
@end


