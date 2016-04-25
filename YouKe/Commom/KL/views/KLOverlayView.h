//
//  KLOverlayView.h
//  SuperCal
//
//  Created by Lu Ming on 13-5-22.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

@end
#import <UIKit/UIKit.h>

@interface KLOverlayView : UIView

///---------------------------------------------------------------------------------------------------------------------
- (void)overlayViewWillAppear:(BOOL)animated;
- (void)overlayViewDidAppear:(BOOL)animated;
- (void)overlayViewAppearingAnimationInitialize;
- (void)overlayViewAppearingAnimationExecute;
- (void)overlayViewAppearingAnimationComplete;


///---------------------------------------------------------------------------------------------------------------------
- (void)overlayViewWillDisappear:(BOOL)animated;
- (void)overlayViewDidDisappear:(BOOL)animated;
- (void)overlayViewDisappearingAnimationInitialize;
- (void)overlayViewDisappearingAnimationExecute;
- (void)overlayViewDisappearingAnimationComplete;


///---------------------------------------------------------------------------------------------------------------------
- (void)showInParent:(UIView *)parent animated:(BOOL)animated duration:(NSTimeInterval)duration animation:(void (^)())animation completion:(void (^)(BOOL finished))completion;

- (void)showAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(void (^)())animation completion:(void (^)(BOOL finished))completion;

- (void)showAnimated:(BOOL)animated animation:(void (^)())animation completion:(void (^)(BOOL finished))completion;

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (void)showAnimated:(BOOL)animated;

///---------------------------------------------------------------------------------------------------------------------
- (void)dismissAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(void (^)())animation completion:(void (^)(BOOL finished))completion;

- (void)dismissAnimated:(BOOL)animated animation:(void (^)())animation completion:(void (^)(BOOL finished))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (void)dismissAnimated:(BOOL)animated;

@end
