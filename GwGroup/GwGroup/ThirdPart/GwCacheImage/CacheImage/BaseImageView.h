//
//  BaseScrollView.h
//  ITTBank
//
//  Created by gao wenjian on 13-1-10.
//
//

#import <UIKit/UIKit.h>
#import "GwImageManager.h"
#import "GwDownloader.h"

@interface BaseImageView : UIScrollView<UIScrollViewDelegate,GwImageManagerDelegate,DownLoaderProcessDelegate>
{
    UIImageView *_baseImageView;
    NSInteger imageViewTag;
//    GwDownloader *_imgDownloader;
}

@property (nonatomic, retain) UIImageView *baseImageView;
@property (nonatomic, assign) NSInteger imageViewTag;

/**
    初始化，设置相关的参数
    @param zoonFlag 是否放大
    @param loadingFlag 是否显示加载
    @param cacheEnable 是否本地缓存,只会内存缓存
 */
- (id)initWithFrame:(CGRect)frame
           imageUrl:(NSString *)url
   placeholderImage:(NSString *)placeholder
           zoomFlag:(BOOL)zoonFlag
        loadingFlag:(BOOL)loadingFlag
        cacheEnabel:(BOOL)cacheEnable;

/**
    启动图片搜索
 */
- (void)loadBigPic;

/**
    取消下载
 */
- (void)baseCancleDownLoad;
@end
