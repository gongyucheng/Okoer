//
//  KLToast.m
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import "KLToast.h"
//#import "PPYUIToolkit.h"

@implementation KLToast

///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for toastView
@dynamic toastColor;
@dynamic cornerRadius;
@dynamic showShadow;
@dynamic shadowWidth;
@dynamic shadowOffset;
@dynamic shadowColor;
@dynamic msgText;
@dynamic msgFont;
@dynamic msgColor;
@dynamic msgInsets;
@dynamic msgLineBreakMode;
@dynamic msgAlignment;


///---------------------------------------------------------------------------------------------------------------------
/// class method
+ (void)showToast:(NSString *)toastText {
    [self showToast:toastText autoDismiss:YES];
}

+ (void)showToast:(NSString *)toastText autoDismiss:(BOOL)autoDismiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        KLToast *toast = [[KLToast alloc] init];
        toast.msgText = toastText;
        toast.autoDismiss = autoDismiss;
        toast.userInteractionEnabled = NO;
        [toast showAnimated:YES];
    });
}


///---------------------------------------------------------------------------------------------------------------------
/// instance method
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _toastView = [[KLToastView alloc] init];
        [self addSubview:_toastView];
        
        _dismissDelay = 3.0f;
        _autoDismiss = YES;
    }
    return self;
}

- (void)overlayViewWillAppear:(BOOL)animated {
    CGRect rect = self.bounds;
    
    _toastView.frame = rect;
    [_toastView sizeToFit];
    _toastView.centerX = CGRectGetMidX(rect);
    _toastView.centerY = CGRectGetMidY(rect);
}

- (void)overlayViewAppearingAnimationComplete {
    if (_autoDismiss) {
        double delayInSeconds = _dismissDelay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissAnimated:YES];
        });
    }
}


///---------------------------------------------------------------------------------------------------------------------
/// @dynamic for toastView
- (UIColor *)toastColor {    return _toastView.toastColor;}
- (void)setToastColor:(UIColor *)toastColor {    _toastView.toastColor = toastColor;}

- (CGFloat)cornerRadius {    return _toastView.cornerRadius;}
- (void)setCornerRadius:(CGFloat)cornerRadius {    _toastView.cornerRadius = cornerRadius;}

- (BOOL)showShadow {    return _toastView.showShadow;}
- (void)setShowShadow:(BOOL)showShadow {    _toastView.showShadow = showShadow;}

- (BOOL)shadowWidth {    return _toastView.shadowWidth;}
- (void)setShadowWidth:(BOOL)shadowWidth {    _toastView.shadowWidth = shadowWidth;}

- (CGSize)shadowOffset {    return _toastView.shadowOffset;}
- (void)setShadowOffset:(CGSize)shadowOffset {    _toastView.shadowOffset = shadowOffset;}

- (UIColor *)shadowColor {    return _toastView.shadowColor;}
- (void)setShadowColor:(UIColor *)shadowColor {    _toastView.shadowColor = shadowColor;}


- (NSString *)msgText {    return _toastView.msgText;}
- (void)setMsgText:(NSString *)msgText
{    _toastView.msgText = msgText;}

- (UIFont *)msgFont {    return _toastView.msgFont;}
- (void)setMsgFont:(UIFont *)msgFont {    _toastView.msgFont = msgFont;}

- (UIColor *)msgColor {    return _toastView.msgColor;}
- (void)setMsgColor:(UIColor *)msgColor {    _toastView.msgColor = msgColor;}

- (UIEdgeInsets)msgInsets {    return _toastView.msgInsets;}
- (void)setMsgInsets:(UIEdgeInsets)msgInsets {    _toastView.msgInsets = msgInsets;}

- (UILineBreakMode)msgLineBreakMode {    return _toastView.msgLineBreakMode;}
- (void)setMsgLineBreakMode:(UILineBreakMode)msgLineBreakMode {    _toastView.msgLineBreakMode = msgLineBreakMode;}

- (UITextAlignment)msgAlignment {    return _toastView.msgAlignment;}
- (void)setMsgAlignment:(UITextAlignment)msgAlignment {    _toastView.msgAlignment = msgAlignment;}


@end
