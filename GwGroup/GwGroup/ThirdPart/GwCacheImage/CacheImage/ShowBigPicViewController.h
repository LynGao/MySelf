//
//  ShowBigPicViewController.h
//  BlockTest
//
//  Created by gao wenjian on 13-9-26.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowBigPicViewController : UIViewController<UIScrollViewDelegate>

/**
    初始化，唯一入口。
    @param position:加载第几张大图
    @param urlArray:图片地址
    @param zoomFlag:是否可以进行缩放
    @param placholder:默认图片
    @param cacheEnable:是否进行本地缓存，但会进行内存缓存
 */
- (id)initWithPosition:(NSInteger)position
         imageUrlArray:(NSMutableArray *)urlArray
              zoomFlag:(BOOL)flag
      placeholderImage:(NSString *)placholder
            cachEnable:(BOOL)cacheEnable;


@end
