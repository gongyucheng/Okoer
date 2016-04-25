//
//  OBPhotoView.m
//  OBNewCar
//
//  Created by Obally on 14-10-26.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import "OBPhotoView.h"
#import "OBPhoto.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface OBPhotoView ()<UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIImageView *_imageView;
    UIImage *_image;
    MBProgressHUD *_hud;
}
@end
@implementation OBPhotoView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 图片
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        // 属性
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 2.0;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = 1.0;
        
        [self addGestureRecognizer:longPress];
    }
    return self;
}
- (void)setPhoto:(OBPhoto *)photo
{
//    if (_photo != photo) {
        _photo = photo;
        [self showImage];
//    }
}

#pragma mark 显示图片
- (void)showImage
{
    __unsafe_unretained OBPhotoView *photoView = self;
    __unsafe_unretained OBPhoto *photo = _photo;
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_photo.urlString] placeholderImage:[UIImage imageNamed:@"loadfiailed"] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (receivedSize == expectedSize) {
            [self performSelectorOnMainThread:@selector(hudhid) withObject:nil waitUntilDone:nil];
        }
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType == SDImageCacheTypeMemory || cacheType == SDImageCacheTypeDisk) {
            [self performSelectorOnMainThread:@selector(hudhid) withObject:nil waitUntilDone:nil];
        }
        if (error) {
            [MBProgressHUD showAlert:@"加载失败，重新试试"];
            [self performSelectorOnMainThread:@selector(hudhid) withObject:nil waitUntilDone:nil];
        }
        
        NSLog(@"%@--------------",[error description]);
        photo.image = image;
        _image = image;
        [photoView adjustFrame];
    }];
}
- (void)hudhid {
    if (_hud) {
        [_hud hide:YES];
        [_hud removeFromSuperview];
    }
}
#pragma mark 调整frame
- (void)adjustFrame
{
    if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;

    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    _imageView.frame = imageFrame;
    if (_photo.firstShow) { // 第一次显示的图片
        _photo.firstShow = NO; // 已经显示过了
        _imageView.frame = CGRectMake(kScreenWidth/2, kScreenHeight/2, 0, 0);
        
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
        
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}
#pragma mark - 手势处理
- (void)SingleTap:(UITapGestureRecognizer *)tap
{
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles:nil, nil];
        [sheet showInView:self];    }
   
}

- (void)hide
{
    self.contentOffset = CGPointZero;
    
    CGFloat duration =0.35;
   
    [UIView animateWithDuration:duration animations:^{
         _imageView.frame = CGRectMake(kScreenWidth/2,kScreenHeight/2, 0,0);
//        _imageView.alpha = 0;
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
    } completion:^(BOOL finished){
            
            // 通知代理
            if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
                [self.photoViewDelegate photoViewDidEndZoom:self];
            }

    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
        [self showAlert:@"保存失败"];
    }else {
        NSLog(@"OK");
        [self showAlert:@"保存成功"];
    }
}

- (void)showAlert:(NSString *)string
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 100)/2, (kScreenHeight - 40)/2, 100, 40)];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
    [self addSubview:label];
    [self performSelector:@selector(removeLabel:) withObject:label afterDelay:1];
}
- (void)removeLabel:(UILabel *)label
{
    [label removeFromSuperview];
}
@end
