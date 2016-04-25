//
//  KLAnimation.h
//  SuperCal
//
//  Created by Lu Ming on 13-9-11.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLAnimation;
@class KLBlockAnimation;
@protocol KLTimeFunction;
@protocol KLPathFunction;


#pragma mark - KLAnimation

@protocol KLAnimationDelegate <NSObject>

- (void)animation:(KLAnimation *)animation progressDidUpdated:(CGFloat)progress;

@optional
- (void)animationDidStop:(KLAnimation *)animation;

@end


@interface KLAnimation : NSObject

@property (nonatomic, readonly) BOOL                      transaction;
@property (nonatomic, readonly) BOOL                      reversed;
@property (nonatomic, assign  ) NSTimeInterval            duration;
@property (nonatomic, assign  ) CGFloat                   frequency;
@property (nonatomic, strong  ) id<KLTimeFunction>        timeFunction;
@property (nonatomic, weak    ) id<KLAnimationDelegate>   delegate;

- (void)startAnimation;
- (void)stopAnimation;
- (void)reverseAnimation;
- (void)resetAnimation;

@end


#pragma mark - KLBlockAnimation

typedef void (^KLAnimationBlock)(KLBlockAnimation *animation, CGFloat progress);


@interface KLBlockAnimation : KLAnimation

@property (nonatomic, copy) KLAnimationBlock callback;

@end


#pragma mark - KLPathAnimation

@protocol KLPathAnimationDelegate <KLAnimationDelegate>

- (void)animation:(KLAnimation *)animation positionDidUpdated:(CGPoint)position;

@end


@interface KLPathAnimation : KLBlockAnimation

@property (nonatomic, strong) NSArray                       *controlPoints;
@property (nonatomic, strong) id<KLPathFunction>            pathFunction;
@property (nonatomic, weak  ) id<KLPathAnimationDelegate>   delegate;

@end
