//
//  Downloader.m
//  BlockTest
//
//  Created by gao wenjian on 13-7-31.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import "GwDownloader.h"
#import "Constant.h"

@interface GwDownloader()
{
    NSURLConnection *_connection;
    NSMutableData *_imgData;
    NSURLRequest *_request;
    
    SuccessDownloadBlock img_successBlock;
    FailDownloadBlock img_failBlock;
    
    long long _contentSize;
}

@end

@implementation GwDownloader
@synthesize url;
@synthesize processDelegate = _processDelegate;

-(void)dealloc
{    
    Block_release(img_failBlock);
    Block_release(img_successBlock);

    if (_connection) {
        [_connection cancel];
    }
    [_connection release];
    
    [_imgData release];
    
    [super dealloc];
}

//-(void)startDownLoadImage:(NSString *)urlString FinishBlock:(void (^)(BOOL, NSData *))block
//{
//    self.url = urlString;
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
////        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
////        if (data) {
////            block(YES,data);
////        }
////    });
//}


-(void)cancleDownload
{
    if (_connection) {
        [_connection cancel];
        _imgData = nil;
    }
}


-(void)beginDownload:(NSString *)urls
{
    self.url = urls;
    [self startDownLoad:self.url];
}

-(void)startDownLoad:(NSString *)urlString
{

    if (!_imgData) {
        _imgData = [[NSMutableData alloc] init];
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    _connection = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_connection start];
    [request release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSDictionary *dic = [(NSHTTPURLResponse *)response allHeaderFields];
    NSString *tempContentLength=[dic objectForKey:@"Content-Length"];
    _contentSize = tempContentLength.longLongValue;
    
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] > 400) {
        
        [self loadDataFail];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_imgData appendData:data];

    if ([_processDelegate respondsToSelector:@selector(downLoadProcess:url:delegate:)] && _contentSize > 0) {
    
        [_processDelegate downLoadProcess:(_imgData.length * 1.00) / (_contentSize * 1.00) url:self.url delegate:_manageDelegate];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self loadDataFinishWithData:_imgData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection fail ==== %@ ",[error userInfo]);
    
    [self loadDataFail];
}

-(void)loadDataFail
{
    [self cancleDownload];
    
    img_failBlock();
}

-(void)loadDataFinishWithData:(NSMutableData *)data
{
    img_successBlock(YES,data);
}

#if NS_BLOCKS_AVAILABLE

-(void)setSuccessDownloadBlock:(SuccessDownloadBlock)success
{
    Block_release(img_successBlock);
    img_successBlock = Block_copy(success);
}

-(void)setFailDownloadBlock:(FailDownloadBlock)fail
{
    Block_release(img_failBlock);
    img_failBlock = Block_copy(fail);
}

#endif

@end
