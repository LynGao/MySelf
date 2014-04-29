//
//  GwImageManager.m
//  BlockTest
//
//  Created by gao wenjian on 13-8-1.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import "GwImageManager.h"

#import "Constant.h"

@interface GwImageManager()
{
    __block GwCachManager *_cach;
    
    NSMutableArray *_test;
}

@property(nonatomic ,retain) NSMutableDictionary *downLoaderDict;
@property(nonatomic ,retain) NSMutableDictionary *delegateDict;

@end

@implementation GwImageManager
@synthesize delegate = _delegate;
@synthesize downLoaderDict,delegateDict;

static GwImageManager *instance = nil;

-(void)dealloc
{
    [_test release];
    [_cach setDelegate:nil];
    [_cach release];
    self.downLoaderDict = nil;
    self.delegateDict = nil;
    [super dealloc];
}

//采用gcd 创建。注意，不能alloc创建改对象
+(GwImageManager *)shareInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        _cach = [GwCachManager shareInstance];
        [_cach setDelegate:self];
        
        self.downLoaderDict = [[[NSMutableDictionary alloc] init] autorelease];
        self.delegateDict = [[[NSMutableDictionary alloc] init] autorelease];
        
        _test = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)gwManagerStartDownloadWithUrl:(NSString *)url withDelegate:(id<GwImageManagerDelegate>)gwDelegate isNeedToShowHud:(BOOL)showHudFlag cacheEnable:(BOOL)cacheEnable;
{
    NSUInteger testinteger = [_test indexOfObjectIdenticalTo:gwDelegate];
    if (testinteger == NSNotFound)
    {
        [_test addObject:gwDelegate];
    }
    
    NSMutableDictionary *conditionDict = [[NSMutableDictionary alloc] init];
    [conditionDict setObject:gwDelegate forKey:GWIMAGEMANAGER_DELEGATE];
    [conditionDict setObject:url forKey:GWIMAGEMANAGER_URL];
    [conditionDict setObject:[NSNumber numberWithBool:showHudFlag] forKey:GWIMAGEMANAGER_SHOWLOADINGFLAG];
    [conditionDict setObject:[NSNumber numberWithBool:cacheEnable] forKey:GWIMAGEMANAGER_CACHEENABLE];
    [_cach checkExitImageCache:url withGwImageMangerCondition:conditionDict];
    [conditionDict release];
}

//取消当前下载的（大图的加载，则不需要调用此方法）
- (void)cancleCurDownLoader:(NSString *)url withDelegate:(id<GwImageManagerDelegate>)gwDelegate
{
    //测试指定的对象是否在数组中不同的是，这里使用指针进行比较
    NSUInteger testinteger = [_test indexOfObjectIdenticalTo:gwDelegate];
    if (testinteger != NSNotFound)
    {
        GwDownloader *downLoder = [[self.downLoaderDict objectForKey:url] retain];
        [downLoder cancleDownload];
        [self.downLoaderDict removeObjectForKey:url];
        [_test removeObjectAtIndex:testinteger];
        [downLoder release];
    }
}


#pragma mark -- GwCachManager delegate
-(void)cachDidFindImageCach:(NSData *)imageData WithGwManagerCondition:(NSMutableDictionary *)condition
{
    id<GwImageManagerDelegate> gwMangerDelegate = [condition objectForKey:GWIMAGEMANAGER_DELEGATE];
    
    if ([gwMangerDelegate respondsToSelector:@selector(gwManagerDidfindImageData:)])
    {
        [gwMangerDelegate gwManagerDidfindImageData:imageData];
    }
}

-(void)cachNotFindImageCach:(NSString *)urlString WithGwManagerCondition:(NSMutableDictionary *)condition
{
    
    id<GwImageManagerDelegate> gwMangerDelegate = [condition objectForKey:GWIMAGEMANAGER_DELEGATE];
    
//    //需要显示，则返回到前以页面.
//    if (showHudFlag) {
//        if ([gwMangerDelegate respondsToSelector:@selector(gwManagerDidNotFindImageData)]) {
//            
//            [gwMangerDelegate gwManagerDidNotFindImageData];
//        }
//    }else{
    
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:urlString,GWIMAGEMANAGER_URL,gwMangerDelegate,GWIMAGEMANAGER_DELEGATE,[condition objectForKey:GWIMAGEMANAGER_CACHEENABLE],GWIMAGEMANAGER_CACHEENABLE,nil];
        [self performSelectorOnMainThread:@selector(toDownLoad:) withObject:dict waitUntilDone:NO];
//    }
}


- (void)toDownLoad:(NSDictionary *)targetDict
{
    
    NSString *urlString = [targetDict objectForKey:GWIMAGEMANAGER_URL];
    id gwMangerDelegate = [targetDict objectForKey:GWIMAGEMANAGER_DELEGATE];
    BOOL cacheEnable = [[targetDict objectForKey:GWIMAGEMANAGER_CACHEENABLE] boolValue];
    
    GwDownloader *imgDownLoader = [self.downLoaderDict objectForKey:urlString];
    
    //处理有相同的url。如果存在，必然是存在依噶下载的对象，此时不需要再去创建。
    if (imgDownLoader) {
        NSLog(@"******** is exit downloader *******");
        return;
    }
    
    if (!imgDownLoader)
    {
        imgDownLoader = [[GwDownloader alloc] init];
        [imgDownLoader setProcessDelegate:self];
        [imgDownLoader setManageDelegate:gwMangerDelegate];
        [self.downLoaderDict setObject:imgDownLoader forKey:urlString];
        [imgDownLoader release];
        
    }
    
    [imgDownLoader setSuccessDownloadBlock:^(BOOL flag,NSData *imgData){
        if(flag){

            if ([gwMangerDelegate respondsToSelector:@selector(gwManagerDidfindImageData:)]){
                [gwMangerDelegate gwManagerDidfindImageData:imgData];
            }
            
            //将downloader delegatedict remove
            [self.downLoaderDict removeObjectForKey:urlString];
            [_test removeObjectIdenticalTo:gwMangerDelegate];
            
            //保存到内存
            [[GwCachManager shareInstance] saveImageDataToMemery:imgData withUrl:urlString];
            
            //如果本地缓存，则保存数据
            if (cacheEnable) {
                dispatch_queue_t saveCacheQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(saveCacheQueue, ^{
                    //保存缓存
                    [[GwCachManager shareInstance] saveImgDataToDisk:imgData withUrl:urlString];
                });
            }
        }
    }];
    
    [imgDownLoader setFailDownloadBlock:^{
        
        if ([gwMangerDelegate respondsToSelector:@selector(gwManagerDidNotFindImageData)]){
             GWJLog(@"________ !~~~~~setFailDownloadBlock fail call back");
            [gwMangerDelegate gwManagerDidNotFindImageData];
        }
    }];
    
    [imgDownLoader beginDownload:urlString];

}

#pragma mark downlader Process delegate
- (void)downLoadProcess:(float)pecent url:(NSString *)url delegate:(id)delegate
{
    if ([delegate respondsToSelector:@selector(gwManagerProcessCallBack:)]) {
        GWJLog(@" 0---- process call back");
        [delegate gwManagerProcessCallBack:pecent];
    }
}
@end
