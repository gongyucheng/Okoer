//
//  PPYGifView.h
//  SuperCal
//
//  Created by Hale Chan on 14-7-18.
//  Copyright (c) 2014年 Beijing PapayaMobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPYGifView : UIImageView

@property (nonatomic, strong)NSData *gifData;

- (instancetype)initWithFrame:(CGRect)frame path:(NSString *)path;
- (instancetype)initWithFrame:(CGRect)frame gifData:(NSData *)gifData;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
