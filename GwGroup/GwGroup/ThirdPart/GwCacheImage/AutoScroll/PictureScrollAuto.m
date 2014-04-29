//
//  PictureScrollAuto.m
//  Tibet5100
//
//  Created by gao wenjian on 13-4-15.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#import "PictureScrollAuto.h"

static float AutoPlayTime = 3;

@interface PictureScrollAuto() {
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSInteger _currentPage;
    NSTimer *_scrollTimer;
    NSInteger _totalPageCount;
    NSMutableArray *_urlArray;
    
    BOOL _cacheFlag;
    BOOL _loadingFlag;
}
@property (nonatomic , retain) NSMutableArray *urlArray;
@property (nonatomic , retain) NSTimer *scrollTimer;
@property (nonatomic , retain) UIScrollView *scrollView;
@property (nonatomic , retain) UIPageControl *pageControl;

//记录baseimageview
@property (nonatomic , retain) NSMutableArray *baseImageArray;

//记录当前3张图片
@property (nonatomic, retain) NSMutableArray *curThreePage;
@end

@implementation PictureScrollAuto
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize scrollTimer = _scrollTimer;
@synthesize delegate = _delegate;
@synthesize urlArray = _urlArray;


-(void)dealloc{
    
    [_baseImageArray release];
    
    if (_urlArray != nil) {
        [_urlArray release];
    }
    
    if (_scrollTimer != nil) {
        if ([_scrollTimer isValid]) {
            [_scrollTimer invalidate];
        }
        [_scrollTimer release];
    }
    
    [_pageControl release];
    [_scrollView release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
           urlArray:(NSMutableArray *)urlArray
   placeholderImage:(NSString *)placehol
        loadingFlag:(BOOL)loadingFlag
          cacheFlag:(BOOL)cacheFlag
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _loadingFlag = loadingFlag;
        _cacheFlag = cacheFlag;
        
        self.baseImageArray = [[[NSMutableArray alloc] init] autorelease];
        
        self.curThreePage = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        
        UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView = tempScrollView;
        [tempScrollView release];
        
        [self.scrollView setBackgroundColor:[UIColor whiteColor]];
        [self.scrollView setDelegate:self];
        [self.scrollView setContentOffset:CGPointZero];
        [self.scrollView setClipsToBounds:NO];
        [self.scrollView setScrollsToTop:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.scrollView];
    
        [self.scrollView setPagingEnabled:YES];
        
        
        UIPageControl *tempPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 10, 320, 10)];
        self.pageControl = tempPage;
        [tempPage release];
        [self.pageControl setNumberOfPages:1];
        [self.pageControl setCurrentPage:0];
        [self.pageControl setBackgroundColor:[UIColor darkGrayColor]];
        [self.pageControl setAlpha:0.6];
        [self addSubview:self.pageControl];


        _currentPage = 0;
        
        [self inputUrlData:urlArray
                 placeHold:placehol];
        
    }
    return self;
}

#pragma mark-- caculate
//begin
- (void)caulateData
{
    
    _pageControl.currentPage = _currentPage;
    
    NSInteger tempPage = _currentPage;
    //pre
    NSInteger pre = tempPage - 1;
    if (pre < 0) {
        //小于0，则前一页就是最好一页。
        pre = self.baseImageArray.count - 1;
    }
    //next
    NSInteger next = tempPage + 1;
    if (next >= self.baseImageArray.count) {
        next = 0;
    }

    [self.curThreePage removeAllObjects];

    BaseImageView *preImage = (BaseImageView *)[self.baseImageArray objectAtIndex:pre];
    BaseImageView *curImage = (BaseImageView *)[self.baseImageArray objectAtIndex:_currentPage];
    [curImage loadBigPic];
    BaseImageView *nextImage = (BaseImageView *)[self.baseImageArray objectAtIndex:next];
    
    [self.curThreePage addObject:preImage];
    [self.curThreePage addObject:curImage];
    [self.curThreePage addObject:nextImage];
    
    for (BaseImageView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.curThreePage.count; i++)
    {
        BaseImageView *image = (BaseImageView *)[self.curThreePage objectAtIndex:i];
        [image setFrame:CGRectMake(_scrollView.frame.size.width * i, 0, image.frame.size.width, image.frame.size.height)];
        [_scrollView addSubview:image];
    }
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * self.curThreePage.count, 0)];
    
    NSLog(@"congse i = %@",NSStringFromCGSize(_scrollView.contentSize));
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}
//end


#pragma mark -
#pragma mark scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.canCycle) {
        int x = scrollView.contentOffset.x;
        if(x >= 2 * scrollView.frame.size.width) {
            _currentPage++;
            if (_currentPage >= self.baseImageArray.count) {
                _canCycle ? _currentPage = 0 : _currentPage--;
            }
            [self caulateData];
        }
        
        if(x <= 0) {
            _currentPage --;
            if (_currentPage < 0) {
                if (_canCycle) {
                    _currentPage = self.baseImageArray.count - 1;
                }else
                    _currentPage = 0;
            }
            
            [self caulateData];
        }
    }else{
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        
        _pageControl.currentPage = page;
        
        if (_currentPage != page) {
            [self loadSubViewAtIndex:page - 1];
            [self loadSubViewAtIndex:page];
            [self loadSubViewAtIndex:page + 1];
        }
        _currentPage = page;
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (self.isNeedAutoPlay) {
//        [self rebuildTimer:YES];
//    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}




#pragma mark customer methods

- (void)loadSubViewAtIndex:(NSInteger)index
{
    
//    if (index < 0) return;
//    if (index >= self.baseImageArray.count) return;
//    
//    [self caulateData];
//    
//    BaseImageView *base = (BaseImageView *)[self.baseImageArray objectAtIndex:index];
//    if (base) {
//        [base loadBigPic];
//    }
    
    [self caulateData];
    
//    if (index < 0) return;
//    if (index >= self.curThreePage.count) return;
    
    BaseImageView *base = (BaseImageView *)[self.curThreePage objectAtIndex:index];
    if (base) {
        [base loadBigPic];
    }
}

- (void)inputUrlData:(NSMutableArray *)urlArrays placeHold:(NSString *)placeHold{
    
    self.urlArray = urlArrays;

    //删除默认图片
    for (BaseImageView *image in self.scrollView.subviews) {
        [image removeFromSuperview];
    }
        
        //重新载入数据
    int pageCount = self.urlArray.count;

    
    if (_canCycle) {
        pageCount = 3;
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * pageCount, self.scrollView.frame.size.height)];

//        CGFloat sizeX = _picWith - (320/2 - _picWith/2 - _picOffset) + (self.urlArray.count - 2) * _picWith + _picOffset * (self.urlArray.count - 2) + 320;
//        NSLog(@"sizex = %f",sizeX);
//         [self.scrollView setContentSize:CGSizeMake(sizeX, self.scrollView.frame.size.height)];
    
    [self.pageControl setNumberOfPages:self.urlArray.count];
    [self.pageControl setCurrentPage:0];

    //总页数
    _totalPageCount = self.urlArray.count;

    if (self.urlArray.count > 0) {
        
            for (int i = 0; i< self.urlArray.count ; i++) {
                
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                
                NSString *url = [self.urlArray objectAtIndex:i];
                //CGRectMake((320 / 2 - _picWith / 2) + _picWith * i + _picOffset * i, 0, _picWith, _picHight)
                BaseImageView *imageView = [[BaseImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i ,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height)
                                                                       imageUrl:url
                                                               placeholderImage:placeHold
                                                                       zoomFlag:NO
                                                                    loadingFlag:_loadingFlag
                                                                    cacheEnabel:_cacheFlag];
                [imageView setContentMode:UIViewContentModeScaleToFill];
                [imageView setUserInteractionEnabled:YES];
                [imageView setTag:(i + 100)];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageHasTap:)];
                [tap setNumberOfTapsRequired:1];
                [imageView addGestureRecognizer:tap];
                [tap release];
//                    [self.scrollView addSubview:imageView];
                [self.baseImageArray addObject:imageView];
                [imageView setTag:100 + i];
                [imageView release];
                
                [pool release];
            }
        
        
//            if (self.isNeedAutoPlay) {
//                if (![self.scrollTimer isValid])
//                    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoPlayPicture) userInfo:nil repeats:YES];
//            }
    
    }
    //处理没有图片的情况
    else{
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:placeHold]];
        [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.scrollView addSubview:imageView];
        [imageView release];
    }
    
    [self loadSubViewAtIndex:0];
    
}

-(void)autoPlayPicture{
   
    if (self.urlArray.count > 0) {
        NSInteger indexToScroll = _currentPage + 1;
        if (indexToScroll == _totalPageCount) {
            indexToScroll = 0;
        }
        [self.scrollView setContentOffset:CGPointMake(320 * indexToScroll, 0) animated:YES];
    }
}


-(void)imageHasTap:(UITapGestureRecognizer *)tap{
    NSString *url = [self.urlArray objectAtIndex:_currentPage];
    [_delegate pictureHasTap:_currentPage UrlString:url];
}

-(void)rebuildTimer:(BOOL)flag{
    if (flag) {
        if (self.scrollTimer != nil) {
            if ([self.scrollTimer isValid]) {
                [self.scrollTimer invalidate];
                self.scrollTimer = nil;
            }
        }
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:AutoPlayTime
                                                            target:self
                                                          selector:@selector(autoPlayPicture)
                                                          userInfo:nil
                                                           repeats:YES];
    }else{
        if ([self.scrollTimer isValid]) {
            [self.scrollTimer invalidate];
            self.scrollTimer = nil;
        }
    }
}
@end
