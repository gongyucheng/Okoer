//
//  OBPhotoView.h
//  OBNewCar
//
//  Created by Obally on 14-10-26.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OBPhoto,OBPhotoBrowser,OBPhotoView;
@protocol OBPhotoViewDelegate <NSObject>

- (void)photoViewImageFinishLoad:(OBPhotoView *)photoView;
- (void)photoViewSingleTap:(OBPhotoView *)photoView;
- (void)photoViewDidEndZoom:(OBPhotoView *)photoView;

@end
@interface OBPhotoView : UIScrollView
@property (nonatomic,retain)OBPhoto *photo;
@property (nonatomic,weak)id<OBPhotoViewDelegate> photoViewDelegate;
@end
