//
//  KLSceneDialog.h
//  SuperCal
//
//  Created by Lu Ming on 13-12-18.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import "KLOverlayView.h"


extern NSString *const kSceneAttributeKeySceneTitle;
extern NSString *const kSceneAttributeKeySceneSize;
extern NSString *const kSceneAttributeKeyAnimationDuration;
extern NSString *const kSceneAttributeKeyAnimationRepeatCount;


@class PPYGifView;
@interface KLSceneDialog : KLOverlayView

@property (nonatomic, readonly) UILabel     *titleLabel;
@property (nonatomic, readonly) PPYGifView *imageView;
@property (nonatomic, readonly) UILabel     *tipLabel;

@property (nonatomic, assign) NSInteger iteratorFirstIndex;
@property (nonatomic, strong) NSString *resourceNameSuffix;

@property (nonatomic, assign) NSTimeInterval switchDuration;

- (void)addSceneWithName:(NSString *)name attributes:(NSDictionary *)attributes;
- (void)removeSceneWithName:(NSString *)name;

@end
