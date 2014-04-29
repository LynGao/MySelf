//
//  GwCachManager.m
//  BlockTest
//
//  Created by gao wenjian on 13-7-31.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import "GwCachManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "Constant.h"
#import <sys/sysctl.h>  
#import <mach/mach.h> 



@interface GwCachManager()
{
    
}

@property (nonatomic,retain) NSOperationQueue *queryCachOnDiskQueue;

@end

@implementation GwCachManager

@synthesize url = _url,delegate = _delegate;
@synthesize memeryCachDict = _memeryCachDict;
@synthesize queryCachOnDiskQueue;

static GwCachManager *instance = nil;

static int Max_time_out_cache = 30 * 24 * 60 * 60;//1 month

-(void)dealloc
{
    [self.queryCachOnDiskQueue cancelAllOperations];
    self.queryCachOnDiskQueue = nil;
    [_memeryCachDict release]; _memeryCachDict = nil;
    [_url release]; _url = nil;
    [super dealloc];
}

//采用gcd 创建。注意，不能alloc创建改对象
+(GwCachManager *)shareInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//初始化数据，检查是否已经有cache目录
-(id)init
{
    self = [super init];
    if (self) {
        
        self.memeryCachDict = [[[NSMutableDictionary alloc] init] autorelease];
        
        //初始化queue
        self.queryCachOnDiskQueue = [[[NSOperationQueue alloc] init] autorelease];
        [queryCachOnDiskQueue setMaxConcurrentOperationCount:5];
     
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *floder = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"GwImage"];
        //创建时间
        BOOL isNeedToCheckCreateDate = YES;
        if (![GwFileManager fileExistsAtPath:floder]) {
            isNeedToCheckCreateDate = NO;
            
            [self createFloader:floder];
        }
        
        if (isNeedToCheckCreateDate)
        {
            BOOL flag = [self checkIsCacheTimeOutWithPath:floder];
            if (flag) {
                
                [GwFileManager removeItemAtPath:floder error:NULL];
                
                [self createFloader:floder];
                
            }
        }

    }
    return self;
}

/**
    此处只缓存 下载完成的数据，如果未全部下载，则不作处理
 */
-(void)checkExitImageCache:(NSString *)urlString withGwImageMangerCondition:(NSMutableDictionary *)conditionDict
{
    NSString *cacheFileName = [self genTempFileName:urlString];
    
    NSString *cachPath = [[[self getCacheContentPath] stringByAppendingPathComponent:@"GwImage"] stringByAppendingPathComponent:cacheFileName];
    
    NSData *tempData = nil;
    
    BOOL memeryFlag = NO;
    
    if ([_memeryCachDict objectForKey:urlString])
    {
        memeryFlag = YES;
        tempData = [_memeryCachDict objectForKey:urlString];
    }
    
    if (memeryFlag) 
    {
        if ([_delegate respondsToSelector:@selector(cachDidFindImageCach: WithGwManagerCondition:)]) {
            
                [_delegate cachDidFindImageCach:tempData WithGwManagerCondition:conditionDict];
        }
    }
    else 
    {
        //是否需要本地缓存。如果需要则去查询本地，否则就直接返回查询失败。
        BOOL cacheEnable = [[conditionDict objectForKey:GWIMAGEMANAGER_CACHEENABLE] boolValue];
        if (cacheEnable) {
            [conditionDict setObject:cachPath forKey:@"cachPath"];
            
            NSInvocationOperation *op = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(queryCachOnDisk:) object:conditionDict] autorelease];
            [self.queryCachOnDiskQueue addOperation:op];

        }else{
            if ([_delegate respondsToSelector:@selector(cachNotFindImageCach:WithGwManagerCondition:)]) {
                
                [_delegate cachNotFindImageCach:urlString WithGwManagerCondition:conditionDict];
            }
        }
        
    }
}

//查找cache文件，可以用多线程
//1.queue
//2.gcd
-(void)queryCachOnDisk:(id)Obj
{
    NSMutableDictionary *reslut = (NSMutableDictionary *)Obj;
    
    NSString *cachPath = [reslut objectForKey:@"cachPath"];
    NSData *tempData = [[NSFileManager defaultManager] contentsAtPath:cachPath];
    if (tempData)
    {
        NSLog(@"did find Loacl Data-----");
        [reslut setObject:tempData forKey:@"data"];
    }
    
    [self performSelectorOnMainThread:@selector(notifiOnMain:) withObject:reslut waitUntilDone:NO];
}

- (void)notifiOnMain:(NSMutableDictionary *)resultDict
{
    NSData *data = [resultDict objectForKey:@"data"];
    NSString *urlString = [resultDict objectForKey:GWIMAGEMANAGER_URL];
   
    if (data) {
        
        if ([self isFullMemeryYet])
        {
            [self clearCache];
        }
        [_memeryCachDict setObject:data forKey:urlString];
    
        if ([_delegate respondsToSelector:@selector(cachDidFindImageCach: WithGwManagerCondition:)])
        {
            [_delegate cachDidFindImageCach:data WithGwManagerCondition:resultDict];
        }
    }else {
        
        [resultDict removeObjectForKey:@"data"];
        
        //下载
        if ([_delegate respondsToSelector:@selector(cachNotFindImageCach: WithGwManagerCondition:)]) {
            [_delegate cachNotFindImageCach:urlString WithGwManagerCondition:resultDict];
        }
    }

}


#pragma mark -
#pragma mark Main Methods
//检查是否缓存过期
-(BOOL)checkIsCacheTimeOutWithPath:(NSString *)path
{
    NSDictionary *distrubute = [GwFileManager attributesOfItemAtPath:path error:NULL];
    
//    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    [formatter setTimeZone:zone];
    
    NSDate *createDate = [distrubute objectForKey:@"NSFileCreationDate"];
//    NSString *dateStr = [formatter stringFromDate:createDate];
    
    long timeCreateStamp = [[NSDate date] timeIntervalSinceDate:createDate];
    
    if (timeCreateStamp > Max_time_out_cache) {
        NSLog(@"is bigger ");
        return YES;
    }else {
        return NO;
    }
    
//    NSDate *date1=[formatter dateFromString:@"2010-3-3 00:00:00"]; 
//    NSDate *date2=[formatter dateFromString:@"2010-3-4 00:00:00"];
//    
//    long t1 = [date2 timeIntervalSinceDate:date1];
//    int days=((int)t1)/(3600*24);
//    int hours=((int)t1)%(3600*24)/3600;
//    
//    NSLog(@"ll = %ld   %@  %@ %d l1 = %ld",timeCreateStamp,createDate,dateStr,hours,t1);
    
    return YES;
}



#pragma mark 写入内存
- (void)saveImageDataToMemery:(NSData *)imgdata withUrl:(NSString *)urlString
{
    if ([self isFullMemeryYet]) {//超过指定的内存大小，删除内存缓存
           [self clearCache];
    }
    //把data 放到 内存缓存中
    if (_memeryCachDict && imgdata) {
        [_memeryCachDict setObject:imgdata forKey:urlString];
    }
}


#pragma mark 写入本地缓存
-(void)saveImgDataToDisk:(NSData *)imgdata withUrl:(NSString *)urlString
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *floder = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"GwImage/%@",[self genTempFileName:urlString]]];
     NSFileManager *manger = [[NSFileManager alloc] init];

    if (imgdata) {
        
        GWJLog(@"***** 直接写入本地");
        [manger createFileAtPath:floder contents:imgdata attributes:nil];
    }else{
        GWJLog(@"*****  写本地做处理触发 %@",urlString);
        UIImage *image = [UIImage imageWithData:[_memeryCachDict objectForKey:urlString]];
        
        if (!image) {
            image = [UIImage imageWithContentsOfFile:floder];
        }
        
        if (image) {
            [manger createFileAtPath:floder
                            contents:UIImagePNGRepresentation(image) //UIImageJPEGRepresentation(image, 1.0)
                          attributes:nil];
        }
    }
    
   [manger release];
    
}

-(void)clearCache
{
    [_memeryCachDict removeAllObjects];
}

-(BOOL)isFullMemeryYet
{
//    //    double usedM = [self usedMemory];
    double avalueM = [self availableMemory];
    GWJLog(@"******* avalueM - = %f /n",avalueM);
    if (avalueM < 50.0) {
        assert(@"---- is less than 50.0M left");
        return YES;
    }
    
    return NO;
}

#pragma mark - 
#pragma mark Util Methods

/**
    图片名。用完整的url转md5
 
    #import <CommonCrypto/CommonDigest.h>
 */
-(NSString *)genTempFileName:(NSString *)urlString
{
    const char *orginString = [urlString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(orginString, strlen(orginString), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
}

//cache path
-(NSString *)getCacheContentPath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    
    return path;
}

//document path
-(NSString *)getDocumentContentPath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    return path;
}

-(void)createFloader:(NSString *)path
{
    [GwFileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:NULL];
}


/**********************************************************************************
 函数名称：
 函数描述：获取当前设备可用内存(单位:MB)
 输入参数：N/A
 输出参数：N/A
 返回的值：double
 *********************************************************************************/
-(double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn
    = host_statistics(mach_host_self(),
                      HOST_VM_INFO,
                      (host_info_t)&vmStats,
                      &infoCount);
    if(kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

/**********************************************************************************
 函数名称：
 函数描述：获取当前任务所占用的内存(单位:MB)
 输入参数：N/A
 输出参数：N/A
 返回的值：double
 *********************************************************************************/
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}


@end
