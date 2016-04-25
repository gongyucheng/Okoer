//
//  KLTimeFunction.m
//  SuperCal
//
//  Created by Lu Ming on 13-9-11.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import "KLTimeFunction.h"

#define LINEAR_IMPLEMENTATION      1
#define QUADRATIC_IMPLEMENTATION   2
#define CUBIC_IMPLEMENTATION       3

#define IMPLEMENTATION_VERSION     QUADRATIC_IMPLEMENTATION


/*
 * the following c methods are transplanted from http://www.gizma.com/easing/#quad3
 */
#pragma mark - quadratic implementation

float quadratic_ease_in(float time)
{
    
    return powf(time, 2.0f);
}

float quadratic_ease_out(float time)
{
    
    // optimized from (-1 * time * (time - 2))
    return time * (2.0f - time);
}

float quadratic_ease_in_out(float time)
{
    
    time *= 2.0f;
    
    if ( time < 1.0f )
        return powf(time, 2.0f) * 0.5f;
    
    time--;
    
    // optimized from (-0.5 * (time * (time - 2) - 1)
    return (1.0f + time * (2.0f - time)) * 0.5f;
}


#pragma mark - cubic implementation

float cubic_ease_in(float time)
{
    
    return powf(time, 3.0f);
}

float cubic_ease_out(float time)
{
    
    time--;
    
    return powf(time, 3.0f) + 1.0f;
}

float cubic_ease_in_out(float time)
{
    
    time *= 2.0f;
    
    if ( time < 1.0f )
        return 0.5f * powf(time, 3.0f);
    
    time -= 2.0f;
    
    return 0.5f * (powf(time, 3.0f) + 2.0f);
}


#pragma mark - KLTimeFunction

@implementation KLLinearTimeFunction

- (CGFloat)progressForTimeProgress:(CGFloat)progress
{
    return progress;
}

@end


@implementation KLEaseInTimeFunction

- (CGFloat)progressForTimeProgress:(CGFloat)progress
{
#if IMPLEMENTATION_VERSION == QUADRATIC_IMPLEMENTATION
    return quadratic_ease_in(progress);
#elif IMPLEMENTATION_VERSION == CUBIC_IMPLEMENTATION
    return cubic_ease_in(progress);
#else
    return progress;
#endif
}

@end


@implementation KLEaseOutTimeFunction

- (CGFloat)progressForTimeProgress:(CGFloat)progress
{
#if IMPLEMENTATION_VERSION == QUADRATIC_IMPLEMENTATION
    return quadratic_ease_out(progress);
#elif IMPLEMENTATION_VERSION == CUBIC_IMPLEMENTATION
    return cubic_ease_out(progress);
#else
    return progress;
#endif
}

@end


@implementation KLEaseInEaseOutTimeFunction

- (CGFloat)progressForTimeProgress:(CGFloat)progress
{
#if IMPLEMENTATION_VERSION == QUADRATIC_IMPLEMENTATION
    return quadratic_ease_in_out(progress);
#elif IMPLEMENTATION_VERSION == CUBIC_IMPLEMENTATION
    return cubic_ease_in_out(progress);
#else
    return progress;
#endif
}

@end
