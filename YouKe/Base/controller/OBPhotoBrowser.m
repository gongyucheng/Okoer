//
//  OBPhotoBrowser.m
//  OBNewCar
//
//  Created by Obally on 14-10-26.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import "OBPhotoBrowser.h"
#import "OBPhoto.h"
#import "OBPhotoView.h"
#import "SDWebImageManager.h"

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)
@interface OBPhotoBrowser () <OBPhotoViewDelegate,UIScrollViewDelegate>
{
    // 滚动的view
    UIScrollView *_photoScrollView;
    // 所有的图片view
    NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    CGFloat screenHeight;
    CGFloat screenWidth;
    BOOL _isIOLLeftOrRight;
}
@end

@implementation OBPhotoBrowser
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];
//    self.view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - KViewWidth(25), kScreenHeight - KViewHeight(30), KViewWidth(50), KViewHeight(20))];
    label.textColor = [UIColor whiteColor];
    label.tag = 2000;
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    screenHeight = kScreenHeight;
    screenWidth = kScreenWidth;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.创建UIScrollView
    [self createScrollView];
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"OBPhotoBrowserDidEnterFullscreenNotification" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"OBPhotoBrowserDidExitFullscreenNotification" object:nil];
}
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    
    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}
#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    [self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
//    _photoScrollView.backgroundColor = [UIColor redColor];
}
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        OBPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = YES;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        OBPhoto *photo = _photos[i];
        photo.firstShow = !(i == currentPhotoIndex);
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}


#pragma mark - 显示照片
- (void)showPhotos
{
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    CGRect visibleBounds = _photoScrollView.bounds;
//    NSInteger firstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
//    NSInteger lastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)- 1) / CGRectGetWidth(visibleBounds));
    NSInteger firstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2 - 1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (OBPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    OBLog(@"----------------firstIndex = %ld",firstIndex);
    OBLog(@"----------------lastIndex = %ld",lastIndex);
    if (firstIndex == lastIndex) {
        UILabel *label = (UILabel *)[self.view viewWithTag:2000];
        label.text = [NSString stringWithFormat:@"%ld/%lu",firstIndex + 1,self.photos.count];
        _currentPhotoIndex = firstIndex;
    }
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSUInteger)index
{
    OBPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) {
        photoView = [[OBPhotoView alloc]init];
        photoView.photoViewDelegate = self;
    }
    CGRect bounds = _photoScrollView.bounds;
    if (_isIOLLeftOrRight) {
        
    }
    
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
//    photoViewFrame.origin.x = (bounds.size.width * index);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    OBPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
    
    
}
#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSInteger)index {
    for (OBPhotoView *photoView in _visiblePhotoViews) {
        if (kPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
    return  NO;
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(NSInteger)index
{
    
    if (index > 0) {
        OBPhoto *photo = _photos[index - 1];
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:photo.urlString] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        }];
    }
    
    if (index < _photos.count - 1) {
        OBPhoto *photo = _photos[index + 1];
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:photo.urlString] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        }];
    }
}

#pragma mark 循环利用某个view
- (OBPhotoView *)dequeueReusablePhotoView
{
    OBPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
     return photoView;
    
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(OBPhotoView *)photoView
{
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)photoViewDidEndZoom:(OBPhotoView *)photoView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)photoViewImageFinishLoad:(OBPhotoView *)photoView
{
//    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isIOLLeftOrRight&& self.photos.count > 1) {
        [self showPhotos];
    }
    
//    [self updateTollbarState];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    OBLog(@"kScreenWidth = %f",kScreenWidth);
    OBLog(@"kScreenHeight = %f",kScreenHeight);
    
    CGFloat height = 0.0;
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        height = 64;
    }
    UILabel *label = (UILabel *)[self.view viewWithTag:2000];
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        _isIOLLeftOrRight = YES;
        self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight - height);
        label.frame = CGRectMake(screenWidth/2 - 25, screenHeight - 30, 50, 20);
        _photoScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight - height);
        _photoScrollView.contentSize = CGSizeMake(screenWidth  *self.photos.count, screenHeight);
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex  * screenWidth + kPadding, 0);
        _isIOLLeftOrRight = NO;
    } else {
        _isIOLLeftOrRight = YES;
        self.view.frame = CGRectMake(0, 0, screenHeight, screenWidth - height);
        label.frame = CGRectMake(screenHeight/2 - 25, screenWidth - 30, 50, 20);
        _photoScrollView.frame = CGRectMake(0, 0, screenHeight, screenWidth - height);
        _photoScrollView.contentSize = CGSizeMake(screenHeight *self.photos.count ,screenWidth);
         _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * screenHeight + kPadding, 0);
        _isIOLLeftOrRight = NO;
    }
    OBPhotoView *photoView = (OBPhotoView *)[self.view viewWithTag: kPhotoViewTagOffset + _currentPhotoIndex];
    if (photoView) {
        [photoView removeFromSuperview];
    }
    [self showPhotoViewAtIndex:_currentPhotoIndex];
    [self.view bringSubviewToFront:label];
}
@end
