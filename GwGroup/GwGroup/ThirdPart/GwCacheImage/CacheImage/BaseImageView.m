//
//  BaseScrollView.m
//  ITTBank
//
//  Created by gao wenjian on 13-1-10.
//
//

#import "BaseImageView.h"
#import "Constant.h"
#import "ProcessView.h"

@interface BaseImageView(){
    NSTimer *_handleTapTimer;
    float maxZoomScla;
    float minZoomScla;
    float currentZoomScla;
    BOOL isZoom;
    BOOL _cacheEnabel;
    BOOL _isDownLoading;
    ProcessView *_processView;
}
@property (nonatomic,retain) NSTimer *_handleTapTimer;
@property (nonatomic,assign) float maxZoomScla;
@property (nonatomic,assign) float minZoomScla;
@property (nonatomic,assign) float currentZoomScla;
@property (nonatomic,assign) BOOL isZoom;

@property (nonatomic,retain) NSString *imageUrl;
@end

@implementation BaseImageView
@synthesize baseImageView = _baseImageView,currentZoomScla,maxZoomScla,minZoomScla,isZoom;
@synthesize _handleTapTimer;
@synthesize imageViewTag;

static float MAX_SCALAR = 3.0;
static float MIN_SCALAR = 1.0;

-(void)dealloc
{
    [self removeObserverForImage];
    self.imageUrl = nil;
    [self stopPostShowToolBarTimer];
    [_processView release];
    [_baseImageView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame imageUrl:(NSString *)url placeholderImage:(NSString *)placeholder zoomFlag:(BOOL)zoonFlag loadingFlag:(BOOL)loadingFlag cacheEnabel:(BOOL)cacheEnable
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor blackColor]];
        
        _cacheEnabel = cacheEnable;
        
        [self addObserverForImage];
        
        [self setTouchEnable:NO];
        
        UIImage *image = [UIImage imageNamed:placeholder];
        _baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_baseImageView setImage:image];
        [self addSubview:_baseImageView];
        self.imageUrl = url;
        
        [self setFrame:CGRectMake(frame.origin.x, 0, frame.size.width , frame.size.height)];
        [self setDelegate:self];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        self.contentMode = UIViewContentModeCenter;
        if (zoonFlag) {
            minZoomScla = MIN_SCALAR;
            maxZoomScla = MAX_SCALAR;
            [self setMaximumZoomScale:maxZoomScla];
            [self setMinimumZoomScale:minZoomScla];
        }
       
        if (loadingFlag) {
            _processView = [[ProcessView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 50 / 2, self.frame.size.height / 2 - 50 / 2, 50, 50)];
            [self addSubview:_processView];
        }
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    CGPoint imagePoint = _baseImageView.frame.origin;
    
    [super setFrame:frame];
    
	self.contentSize = CGSizeMake(frame.size.width * self.zoomScale, frame.size.height * self.zoomScale );
	
    if (_baseImageView.frame.size.width >= frame.size.width) {
        _baseImageView.frame = CGRectMake(imagePoint.x, imagePoint.y, frame.size.width * self.zoomScale, frame.size.height * self.zoomScale);
    }else{
        _baseImageView.frame = CGRectMake(imagePoint.x, imagePoint.y, _baseImageView.frame.size.width * self.zoomScale, _baseImageView.frame.size.height * self.zoomScale);
    }
}

- (void)addObserverForImage
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetImageSize:) name:RESETDETAILIMAGEVIEW object:nil];
}

- (void)removeObserverForImage
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RESETDETAILIMAGEVIEW object:nil];
}

//在放大标识打开的情况下：在图片下载完成之前，不允许进行放大。
- (void)setTouchEnable:(BOOL)enable
{
    [self setUserInteractionEnabled:enable];
}

#pragma mark download method
//下载图片
- (void)loadBigPic
{
    if (_isDownLoading) {
        return;
    }
    //使用manger，获取缓存。不存在
    GwImageManager *manager = [GwImageManager shareInstance];
    [manager gwManagerStartDownloadWithUrl:self.imageUrl
                              withDelegate:self
                           isNeedToShowHud:YES
                               cacheEnable:_cacheEnabel];
}

#pragma mark manger delegate
- (void)gwManagerDidfindImageData:(NSData *)data
{
    GWJLog(@"Had found data");
   
    [self setTouchEnable:YES];
    
    [self removeProcess];
    
    [self performSelectorOnMainThread:@selector(setImageWithData:) withObject:data waitUntilDone:NO];
    
    }

- (void)gwManagerDidNotFindImageData
{
    GWJLog(@"Need To down Load");
    //do nothing
}

- (void)gwManagerProcessCallBack:(float)percent
{
    GWJLog(@"%f",percent);
    if (_processView) {
        [_processView setProcess:percent];
        [_processView setNeedsDisplay];
        
        if (percent >= 1) {//done
            [self removeProcess];
        }
    }
}

- (void)removeProcess
{
    [_processView removeFromSuperview];
}

- (void)setImageWithData:(NSData *)imageData
{
    
    UIImage *image = [UIImage imageWithData:imageData];
    CGRect frame = [self caculateRect:image];
    UIImage *newImage = [self fitScreenImage:image targetFrame:frame];
    [_baseImageView setImage:newImage];
    [_baseImageView setFrame:frame];
    
    
    
//    UIImage *image = [UIImage imageWithData:imageData];
//    [_baseImageView setImage:image];
//    if (image.size.width > self.frame.size.width) {//超过屏幕宽度
//        
//        CGFloat curX = 0;
//        CGFloat curY = 0;
//        CGFloat curWidth = self.frame.size.width;
//        CGFloat curHight = self.frame.size.height * image.size.width / self.frame.size.width;
//        
//        if (curHight > self.frame.size.height) {//缩放后，超过屏幕的高度
//            curY = 0;curHight = self.frame.size.height;
//        }
//        [_baseImageView setFrame:CGRectMake(curX, curY, curWidth, curHight)];
//    }else{
//        //判断高
//        CGFloat curX = 0;
//        CGFloat curY = 0;
//        CGFloat curWidth = 0;
//        CGFloat curHight = 0;
//        if (image.size.height > self.frame.size.height) {
//            curX = self.frame.size.width/2 - image.size.width/2;
//            curY = 0;
//            curHight = self.frame.size.height * image.size.width / self.frame.size.width;
//            curWidth = self.frame.size.width * image.size.height / self.frame.size.height;
//            if (curWidth > self.frame.size.width) {
//                curX = 0;
//                curWidth = self.frame.size.width;
//            }
//        }else{
//            curX = self.frame.size.width/2 - image.size.width/2;
//            curY = self.frame.size.height/2 - image.size.height/2;
//            curWidth = image.size.width;
//            curHight = image.size.height;
//        }
//        [_baseImageView setFrame:CGRectMake(curX, curY, curWidth, curHight)];
//    }
}

#pragma mark -- 对超过屏幕大小的图片进行缩放处理。
- (UIImage *)fitScreenImage:(UIImage *)targetImage targetFrame:(CGRect)targetFrame
{
    if (!targetImage) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(targetFrame.size);
    [targetImage drawInRect:targetFrame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGRect)caculateRect:(UIImage *)image
{
    CGFloat curX = 0;
    CGFloat curY = 0;
    CGFloat curWidth = 0;
    CGFloat curHight = 0;
    
    if (image.size.width > self.frame.size.width) {//超过屏幕宽度
        
        curX = 0;
        curY = 0;
        curWidth = self.frame.size.width;
        curHight = self.frame.size.height * image.size.width / self.frame.size.width;
        
        if (curHight > self.frame.size.height) {//缩放后，超过屏幕的高度
            curY = 0;curHight = self.frame.size.height;
        }
        
    }else if (image.size.height > self.frame.size.height) {
        curX = self.frame.size.width/2 - image.size.width/2;
        curY = 0;
        curHight = self.frame.size.height * image.size.width / self.frame.size.width;
        curWidth = self.frame.size.width * image.size.height / self.frame.size.height;
        if (curWidth > self.frame.size.width) {
            curX = 0;
            curWidth = self.frame.size.width;
        }
    }else{
        curX = self.frame.size.width/2 - image.size.width/2;
        curY = self.frame.size.height/2 - image.size.height/2;
        curWidth = image.size.width;
        curHight = image.size.height;
    }
    
    
    return CGRectMake(curX, curY, curWidth, curHight);
}


#pragma mark scorllview delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (maxZoomScla > 0) {
            return _baseImageView;
    }else
        return nil;
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //开始缩放
    isZoom = YES;
    
    //控制每次的缩放，让图片保持在屏幕的中间
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0.0;
    
    [_baseImageView setCenter:CGPointMake(scrollView.contentSize.width / 2 + offsetX, scrollView.contentSize.height / 2+ offsetY)];
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    self.currentZoomScla = scale;
    if (self.currentZoomScla == self.minimumZoomScale)
        isZoom = NO;
    else
        isZoom = YES;
}

#pragma mark touch method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        [self stopPostShowToolBarTimer];
        if (isZoom) {
            //当前未放大状态，需要缩小
            isZoom = NO;
            [self setZoomScale:minZoomScla animated:YES];
        }else{
            //当前缩小状态，需要放大
            isZoom=YES;
            CGPoint tapPoint = [touch locationInView:_baseImageView];
        
            CGSize ZoomNeedSize = CGSizeMake(_baseImageView.frame.size.width/maxZoomScla, _baseImageView.frame.size.height/maxZoomScla);

            
            CGRect ZoomNeedRect = CGRectMake(tapPoint.x - ZoomNeedSize.width/2, tapPoint.y - ZoomNeedSize.height/2, ZoomNeedSize.width, ZoomNeedSize.height);
            
            
            //在放大过程中，需要设定边界值，从而显示靠边界的地方。
            //left
            if (ZoomNeedRect.origin.x < 0) {
                ZoomNeedRect = CGRectMake(0, ZoomNeedRect.origin.y, ZoomNeedRect.size.width, ZoomNeedRect.size.height);
            }
            
            //up
            if (ZoomNeedRect.origin.y < 0) {
                ZoomNeedRect = CGRectMake(ZoomNeedRect.origin.x, 0, ZoomNeedRect.size.width, ZoomNeedRect.size.height);
            }
            
            //right
            if (ZoomNeedRect.origin.x + ZoomNeedRect.size.width > self.frame.size.width) {
                ZoomNeedRect = CGRectMake(self.frame.size.width - ZoomNeedRect.size.width, ZoomNeedRect.origin.y, ZoomNeedRect.size.width, ZoomNeedRect.size.height);
            }
            
            //down
            if (ZoomNeedRect.origin.y+ZoomNeedRect.size.height > self.frame.size.height) {
                ZoomNeedRect = CGRectMake(ZoomNeedRect.origin.x, self.frame.size.height - ZoomNeedRect.size.height, ZoomNeedRect.size.width, ZoomNeedRect.size.height);
            }
            
            //放大指定区域
            [self zoomToRect:ZoomNeedRect animated:YES];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([[event allTouches] count] == 1 ) {
		UITouch *touch = [[event allTouches] anyObject];
		if( touch.tapCount == 1 ) {
			if(_handleTapTimer ) [self stopPostShowToolBarTimer];
			[self postShowToolBarTimer];
		}
	}
}

#pragma mark customer method
- (void)postShowToolBarTimer
{
    _handleTapTimer= [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.5f] interval:0.5f target:self selector:@selector(postNotification) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_handleTapTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopPostShowToolBarTimer
{
	if([_handleTapTimer isValid])
		[_handleTapTimer invalidate];
    [_handleTapTimer release];
	_handleTapTimer = nil;
    
}


-(void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDENTOOLBAR object:nil];
}

//重置图片大小
-(void)resetImageSize:(NSNotification *)notification
{
    NSInteger currentImageViewTag = [[notification object] integerValue];
    if (currentImageViewTag != self.imageViewTag - 100) {
        if (isZoom) {
            isZoom = NO;
            [self setZoomScale:minZoomScla animated:YES];
        }
    }
}


- (void)baseCancleDownLoad
{
    [[GwImageManager shareInstance] cancleCurDownLoader:self.imageUrl withDelegate:self];
}
@end
