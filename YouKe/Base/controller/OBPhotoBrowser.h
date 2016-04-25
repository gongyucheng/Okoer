//
//  OBPhotoBrowser.h
//  OBNewCar
//
//  Created by Obally on 14-10-26.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

//#import "uivie"
@class OBPhotoBrowser;
@protocol OBPhotoBrowserDelegate <NSObject>

//切换到某一张图片
- (void)photoBrowser:(OBPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

@end
@interface OBPhotoBrowser : UIViewController

@property (nonatomic, weak) id<OBPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, retain) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

// 显示
- (void)show;

@end
