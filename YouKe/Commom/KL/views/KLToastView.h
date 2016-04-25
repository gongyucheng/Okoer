//
//  KLToastView.h
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLToastView : UIView

@property (nonatomic, strong) UIColor *toastColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL showShadow;
@property (nonatomic, assign) BOOL shadowWidth;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, strong) UIColor *shadowColor;

@property (nonatomic, strong) NSString *msgText;
@property (nonatomic, strong) UIFont *msgFont;
@property (nonatomic, strong) UIColor *msgColor;
@property (nonatomic, assign) UIEdgeInsets msgInsets;
@property (nonatomic, assign) NSLineBreakMode msgLineBreakMode;
@property (nonatomic, assign) NSTextAlignment msgAlignment;

@end
