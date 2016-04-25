//
//  KLAnimation.m
//  SuperCal
//
//  Created by Lu Ming on 13-9-11.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import "KLAnimation.h"
#import "KLTimeFunction.h"
#import "KLPathFunction.h"

NSTimeInterval const kAnimationDefaultDuration = 0.3;
CGFloat const kAnimationDefaultFrequency = 25;


#pragma mark - KLAnimation

@interface KLAnimation ()
{
@private
    NSTimer *_timer;
    CGFloat _progress;
    CGFloat _direction;
    CGFloat _step;
}

@end


@implementation KLAnimation

- (id)init
{
    self = [super init];
    if (self) {
        self.duration = kAnimationDefaultDuration;
        self.timeFunction = [[KLLinearTimeFunction alloc] init];
        self.frequency = kAnimationDefaultFrequency;
        _transaction = NO;
    }
    return self;
}

- (CGFloat)progressForTimeProgress:(CGFloat)progress
{
    return [self.timeFunction progressForTimeProgress:progress];
}

- (BOOL)shouldAnimationStopForTimeProgress:(CGFloat)progress
{
    BOOL shouldStop = NO;
    
    if (_progress > _duration)
    {
        shouldStop = YES;
        
        _progress = _duration;
    }
    else if (_progress < 0)
    {
        shouldStop = YES;
        
        _progress = 0;
    }
    
    return shouldStop;
}

- (CGFloat)nextProgress
{
    _progress += _step * _direction;
    
    if ([self shouldAnimationStopForTimeProgress:_progress])
    {
        [self stopAnimation];
        
        [self notifyDelegateAnimationStoped];
    }
    
    CGFloat progress = [self progressForTimeProgress:(_progress / _duration)];
    
    [self notifyDelegateWithProgress:progress];
    
    return progress;
}

- (void)timerHandler:(NSTimer *)timer
{
    [self nextProgress];
}

- (void)scheduleTimer
{
    if (_timer) return;
    
    _transaction = YES;
    
    _timer = [NSTimer timerWithTimeInterval:_step target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes]; // timer must run in common mode, or timer will be blocked by scrolling(UITableView)
}

- (void)notifyDelegateAnimationStoped
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStop:)])
    {
        [self.delegate animationDidStop:self];
    }
}

- (void)notifyDelegateWithProgress:(CGFloat)progress
{
    if (self.delegate)
    {
        [self.delegate animation:self progressDidUpdated:progress];
    }
}

#pragma mark - interface

- (void)startAnimation
{
    _direction = 1.0f;
    
    [self scheduleTimer];
}

- (void)stopAnimation
{
    [_timer invalidate];
    
    _timer = nil;
    
    _transaction = NO;
}

- (void)reverseAnimation
{
    _direction = -1.0f;
    
    [self scheduleTimer];
}

- (void)resetAnimation
{
    _progress = 0.0f;
    
    _direction = 1.0f;
}

#pragma mark - dynamic

- (BOOL)reversed
{
    return _direction < 0;
}

#pragma mark - override

- (void)setFrequency:(CGFloat)frequency
{
    _frequency = frequency;
    _step = 1.0f / frequency;
}

@end



#pragma mark - KLBlockAnimation

@implementation KLBlockAnimation

- (void)notifyDelegateWithProgress:(CGFloat)progress
{
    [super notifyDelegateWithProgress:progress];
    
    if (self.callback)
    {
        self.callback(self, progress);
    }
}

@end



#pragma mark - KLPathAnimation

@implementation KLPathAnimation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _pathFunction = [[KLLinearPathFunction alloc] init];
    }
    
    return self;
}

- (CGPoint)positionForTimeProgress:(CGFloat)progress
{
    return [[self pathFunction] positionForTimeProgress:progress withControlPoints:self.controlPoints];
}

- (void)notifyDelegateWithPoint:(CGPoint)point
{
    if (self.delegate)
    {
        [self.delegate animation:self positionDidUpdated:point];
    }
}

- (CGFloat)nextProgress
{
    CGFloat progress = [super nextProgress];
    
    CGPoint point = [self positionForTimeProgress:progress];
    
    [self notifyDelegateWithPoint:point];
    
    return progress;
}

@end
