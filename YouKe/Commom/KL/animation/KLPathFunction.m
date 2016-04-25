//
//  KLPathFunction.m
//  SuperCal
//
//  Created by LuMing on 14-5-7.
//  Copyright (c) 2014年 Beijing PapayaMobile Inc. All rights reserved.
//

#import "KLPathFunction.h"

static inline float CGPointGetDistance(CGPoint p1, CGPoint p2)
{
    return sqrtf(powf(p2.x - p1.x, 2) + powf(p2.y - p1.y, 2));
}

static inline CGPoint CGPointGetMidPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p2.x - p1.x) * 0.5f, (p2.y - p1.y) * 0.5f);
}

@interface KLLinearPathFunction ()

@end

@implementation KLLinearPathFunction

- (CGPoint)positionForTimeProgress:(CGFloat)progress withControlPoints:(NSArray *)points
{
    NSInteger pc = points.count;    // point count
    
    NSAssert(pc >= 2, @"control points count is %ld, are you kidding me?", (long)pc);
    
    return CGPointZero;
}

@end

@implementation KLBezierPathFunction

- (CGPoint)positionForTimeProgress:(CGFloat)progress withControlPoints:(NSArray *)points
{
    return CGPointZero;
}

@end
