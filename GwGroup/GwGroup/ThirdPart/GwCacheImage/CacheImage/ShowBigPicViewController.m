//
//  ShowBigPicViewController.m
//  BlockTest
//
//  Created by gao wenjian on 13-9-26.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import "ShowBigPicViewController.h"
#import "BaseImageView.h"
#import "Constant.h"

@interface ShowBigPicViewController ()
{
    UIScrollView *_contentPicScrollView;
    UIToolbar *_toolBar;
    NSInteger _curPosition;
    BOOL _zoomFlag;
    BOOL _cacheEnable;
    NSString *_placeholderImage;
}
@property (nonatomic, retain) NSMutableArray *urlsArray;
@property (nonatomic, retain) NSMutableArray *imageArray;
@end

@implementation ShowBigPicViewController

- (void)dealloc
{
    //大图处理，取消下载
    for (BaseImageView *base in _imageArray) {
        if ((NSNull *)base != [NSNull null]) {
            [base baseCancleDownLoad];
        }
    }
    [_placeholderImage release];
    [self removeOB];
    [_imageArray release];
    [_urlsArray release];
    [_toolBar release];
    [_contentPicScrollView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self addOB];
    [self prepareBaseScrollView];
    [self setUpToolBar];
    [self loadSubViewAtIndex:_curPosition];
    //没有动画，进行加载到指定的页面。
    [_contentPicScrollView setContentOffset:CGPointMake(320 * _curPosition, 0.0f) animated:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark client methods
- (id)initWithPosition:(NSInteger)position imageUrlArray:(NSMutableArray *)urlArray zoomFlag:(BOOL)flag placeholderImage:(NSString *)placholder cachEnable:(BOOL)cacheEnable;
{
    self = [super init];
    if (self)
    {
        _curPosition = position;
        _zoomFlag = flag;
        _cacheEnable = cacheEnable;
        _placeholderImage = [placholder copy];
        self.urlsArray = urlArray;
    
    }
    return self;
}

- (void)addOB
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDoubleTapFinish) name:HIDDENTOOLBAR object:nil];
}

- (void)removeOB
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HIDDENTOOLBAR object:nil];
}

//处理是否隐藏toolbar
-(void)handleDoubleTapFinish
{
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView animateWithDuration:0.2f
                     animations:^{
                         if (_toolBar.alpha==0.0)
                             _toolBar.alpha=1.0;
                         else
                             _toolBar.alpha=0.0;
                     } completion:^(BOOL finish){
                         
                     }];
}

- (void)dismissController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setUpToolBar
{
    //初始化tool bar
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [_toolBar setBarStyle:UIBarStyleBlack];
    [_toolBar setTranslucent:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissController)];
    
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
//    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(removeCache)];
    
    [_toolBar setItems:[NSArray arrayWithObjects:item,nil]];
    [item release];
//    [item1 release];
//    [clearItem release];
    
    [self.view addSubview:_toolBar];
}

//- (void)removeCache
//{
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *floder = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"GwImage"];
//    [GwFileManager removeItemAtPath:floder error:NULL];
//}

#pragma mark 初始化scrollview
- (void)prepareBaseScrollView
{
    self.imageArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0;i < self.urlsArray.count;i++)
    {
        [self.imageArray addObject:[NSNull null]];
    }
    _contentPicScrollView = [[UIScrollView alloc] init];
    [_contentPicScrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_contentPicScrollView setBackgroundColor:[UIColor clearColor]];
    [_contentPicScrollView setPagingEnabled:YES];
    [_contentPicScrollView setDelegate:self];
    [_contentPicScrollView setShowsHorizontalScrollIndicator:YES];
    [_contentPicScrollView setShowsVerticalScrollIndicator:NO];
    [_contentPicScrollView setContentSize:CGSizeMake(self.view.frame.size.width * _urlsArray.count, self.view.frame.size.height)];
    [self.view addSubview:_contentPicScrollView];
    
}

- (void)loadSubViewAtIndex:(NSInteger)index
{
    if (index < 0) return;
    if (index >= self.imageArray.count) return;
    BaseImageView *base = (BaseImageView *)[self.imageArray objectAtIndex:index];
    if ([NSNull null] == (NSNull *)base)
    {
        base = [[BaseImageView alloc] initWithFrame:CGRectMake(320 * index, 0, 320, self.view.frame.size.height)
                                            imageUrl:[self.urlsArray objectAtIndex:index]
                                   placeholderImage:_placeholderImage
                                           zoomFlag:_zoomFlag
                                        loadingFlag:YES
                                        cacheEnabel:_cacheEnable];
        
        [self.imageArray replaceObjectAtIndex:index withObject:base];
        [base release];
    }
    if (nil == base.superview)
    {
        [_contentPicScrollView addSubview:(BaseImageView *)[self.imageArray objectAtIndex:index]];
    }
    [base loadBigPic];
}


#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (_curPosition != page)
    {
        //发出通知，让放大了的图片，变回原来的size
        [[NSNotificationCenter defaultCenter] postNotificationName:RESETDETAILIMAGEVIEW object:[NSString stringWithFormat:@"%d",_curPosition]];
        
        [self loadSubViewAtIndex:page - 1];
        [self loadSubViewAtIndex:page];
        [self loadSubViewAtIndex:page + 1];
        _curPosition = page;
    }
}


@end
