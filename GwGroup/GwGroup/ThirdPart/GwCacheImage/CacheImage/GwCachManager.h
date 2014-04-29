//
//  GwCachManager.h
//  BlockTest
//
//  Created by gao wenjian on 13-7-31.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GwCachManagerDelegate <NSObject>

- (void)cachDidFindImageCach:(NSData *)imageData WithGwManagerCondition:(NSMutableDictionary *)condition;

- (void)cachNotFindImageCach:(NSString *)fileName WithGwManagerCondition:(NSMutableDictionary *)condition;

@end

@interface GwCachManager : NSObject
{
    NSString *_url;
    id<GwCachManagerDelegate> _delegate;
    
    NSMutableDictionary *_memeryCachDict;//内存缓存,将缓存文件读取之后，保存在内存中，下一次再 读取时可以不用去load本地
}

@property (nonatomic, retain) NSMutableDictionary *memeryCachDict;
@property (nonatomic, assign) id<GwCachManagerDelegate> delegate;
@property (nonatomic, copy) NSString *url;

+ (GwCachManager *)shareInstance;

/**
    检查是否有缓存
 */
- (void)checkExitImageCache:(NSString *)urlString
 withGwImageMangerCondition:(NSMutableDictionary *)conditionDict;

/**
    写入本地
 */
- (void)saveImgDataToDisk:(NSData *)imgdata
                  withUrl:(NSString *)urlString;

/**
    写入内存
 */
- (void)saveImageDataToMemery:(NSData *)imgdata
                      withUrl:(NSString *)urlString;
@end
