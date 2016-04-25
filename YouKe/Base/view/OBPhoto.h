//
//  OBPhoto.h
//  OBNewCar
//
//  Created by Obally on 14-10-26.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBPhoto : NSObject
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, retain) UIImage *image; // 完整的图片

@property (nonatomic, retain) UIImageView *srcImageView; // 来源view
@property (nonatomic, retain, readonly) UIImage *placeholder;
@property (nonatomic, retain, readonly) UIImage *capture;

@property (nonatomic, assign) BOOL firstShow;

// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;
@property (nonatomic, assign) int index; // 索引
@end
