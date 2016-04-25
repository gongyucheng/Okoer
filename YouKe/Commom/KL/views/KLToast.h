//
//  KLToast.h
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import "KLOverlayView.h"
#import "KLToastView.h"

@interface KLToast : KLOverlayView

+ (void)showToast:(NSString *)toastText; // quick show a toast
+ (void)showToast:(NSString *)toastText autoDismiss:(BOOL)autoDismiss;
@property (nonatomic, strong) KLToastView *toastView;
@property (nonatomic, assign) BOOL autoDismiss;
@property (nonatomic, assign) NSTimeInterval dismissDelay;


///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for toastView
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
@property (nonatomic, assign) UILineBreakMode msgLineBreakMode;
@property (nonatomic, assign) UITextAlignment msgAlignment;


@end
