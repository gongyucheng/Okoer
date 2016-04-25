//
//  KLDialogTitleView.h
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLDialogTitleView : UIView

@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, assign) CGSize logoSize;

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) NSTextAlignment titleAlignment;
@property (nonatomic, assign) NSLineBreakMode titleLineBreakMode;
@property (nonatomic, assign) NSInteger titleNumberOfLines;

@end
