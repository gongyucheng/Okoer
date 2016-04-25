//
//  KLOverlayView.m
//  SuperCal
//
//  Created by Lu Ming on 13-5-22.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import "KLOverlayView.h"
//#import "PPYUIToolkit.h"

@implementation KLOverlayView

///---------------------------------------------------------------------------------------------------------------------
- (void)overlayViewWillAppear:(BOOL)animated {}

- (void)overlayViewDidAppear:(BOOL)animated {}

- (void)overlayViewAppearingAnimationInitialize {
    self.alpha = 0;
}

- (void)overlayViewAppearingAnimationExecute {
    self.alpha = 1;
}

- (void)overlayViewAppearingAnimationComplete {}


///---------------------------------------------------------------------------------------------------------------------
- (void)overlayViewWillDisappear:(BOOL)animated {}

- (void)overlayViewDidDisappear:(BOOL)animated {}

- (void)overlayViewDisappearingAnimationInitialize {}

- (void)overlayViewDisappearingAnimationExecute {
    self.alpha = 0;
}

- (void)overlayViewDisappearingAnimationComplete {}


///---------------------------------------------------------------------------------------------------------------------
- (void)showInParent:(UIView *)parent animated:(BOOL)animated duration:(NSTimeInterval)duration animation:(void (^)())animation completion:(void (^)(BOOL finished))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = parent.bounds;
        [parent addSubview:self];
        [self overlayViewWillAppear:animated];
        
        void (^animationInitialize)() = ^{
            [self overlayViewAppearingAnimationInitialize];
        };
        
        void (^animationInternal)() = ^{
            [self overlayViewAppearingAnimationExecute];
            if (animation)
                animation();
        };
        
        void (^completionInternal)(BOOL) = ^(BOOL finished) {
            [self overlayViewAppearingAnimationComplete];
            [self overlayViewDidAppear:animated];
            if (completion)
                completion(finished);
        };
        
        animationInitialize();
        if (animated) {
            [UIView animateWithDuration:duration animations:animationInternal completion:completionInternal];
        }
        else {
            animationInternal();
            completionInternal(YES);
        }
    });
}

- (void)showAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(void (^)())animation completion:(void (^)(BOOL finished))completion {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    [self showInParent:lastWindow animated:animated duration:duration animation:animation completion:completion];
}

- (void)showAnimated:(BOOL)animated animation:(void (^)())animation completion:(void (^)(BOOL finished))completion {
    [self showAnimated:animated duration:PPY_ANIMATION_DURATION animation:animation completion:completion];
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self showAnimated:animated animation:nil completion:completion];
}

- (void)showAnimated:(BOOL)animated {
    [self showAnimated:animated completion:nil];
}


///---------------------------------------------------------------------------------------------------------------------
- (void)dismissAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(void (^)())animation completion:(void (^)(BOOL finished))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self overlayViewWillDisappear:animated];
        
        void (^animationInitialize)() = ^{
            [self overlayViewDisappearingAnimationInitialize];
        };
        
        void (^animationInternal)() = ^{
            [self overlayViewDisappearingAnimationExecute];
            if (animation)
                animation();
        };
        
        void (^completionInternal)(BOOL) = ^(BOOL finished) {
            [self overlayViewDisappearingAnimationComplete];
            [self removeFromSuperview];
            [self overlayViewDidDisappear:animated];
            if (completion)
                completion(finished);
        };
        
        animationInitialize();
        if (animated) {
            [UIView animateWithDuration:duration animations:animationInternal completion:completionInternal];
        }
        else {
            animationInternal();
            completionInternal(YES);
        }
    });
}

- (void)dismissAnimated:(BOOL)animated animation:(void (^)())animation completion:(void (^)(BOOL finished))completion {
    [self dismissAnimated:animated duration:PPY_ANIMATION_DURATION animation:animation completion:completion];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self dismissAnimated:animated animation:nil completion:completion];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAnimated:animated completion:nil];
}


@end
