//
//  Downloader.h
//  BlockTest
//
//  Created by gao wenjian on 13-7-31.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessDownloadBlock)(BOOL flag,NSData *data);

typedef void (^FailDownloadBlock)();

@protocol DownLoaderProcessDelegate <NSObject>

- (void)downLoadProcess:(float)pecent url:(NSString *)url delegate:(id)delegate;

@end

@interface GwDownloader : NSObject<NSURLConnectionDataDelegate>
{
    id<DownLoaderProcessDelegate> _processDelegate;
}

@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) id<DownLoaderProcessDelegate> processDelegate;
@property (nonatomic, retain) id manageDelegate;


//-(void)startDownLoadImage:(NSString *)url FinishBlock:(void (^)(BOOL isFinish,NSData *imgData))block;

- (void)cancleDownload;

- (void)setSuccessDownloadBlock:(SuccessDownloadBlock)success;

- (void)setFailDownloadBlock:(FailDownloadBlock)fail;

- (void)beginDownload:(NSString *)url;

- (void)startDownLoad:(NSString *)urlString;
@end
