//
//  GwImageManager.h
//  BlockTest
//
//  Created by gao wenjian on 13-8-1.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GwCachManager.h"
#import "GwDownloader.h"

@protocol GwImageManagerDelegate <NSObject>

- (void)gwManagerDidfindImageData:(NSData *)data;

- (void)gwManagerDidNotFindImageData;

- (void)gwManagerProcessCallBack:(float)percent;

@end

@interface GwImageManager : NSObject<GwCachManagerDelegate,DownLoaderProcessDelegate>
{
    id<GwImageManagerDelegate> _delegate;
}

@property(nonatomic,retain) id<GwImageManagerDelegate> delegate;


+ (GwImageManager *)shareInstance;

/**
    提供一个入口，统一的一个返回数据，这样子，caterlo类就可以唯一接收数据显示。
    @param showHudFlag 是否返回下载进度
    @param cacheEnable 是否进行本地缓存
 */
- (void)gwManagerStartDownloadWithUrl:(NSString *)url
                        withDelegate:(id<GwImageManagerDelegate>)gwDelegate
                     isNeedToShowHud:(BOOL)showHudFlag
                         cacheEnable:(BOOL)cacheEnable;

/**
    取消下载。PS：查看大图时，当关闭查看的controller时，调用此方法来取消下载。
 */
- (void)cancleCurDownLoader:(NSString *)url
               withDelegate:(id<GwImageManagerDelegate>)gwDelegate;

@end
