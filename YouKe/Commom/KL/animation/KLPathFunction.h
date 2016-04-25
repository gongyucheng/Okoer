//
//  KLPathFunction.h
//  SuperCal
//
//  Created by LuMing on 14-5-7.
//  Copyright (c) 2014年 Beijing PapayaMobile Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLPathFunction

- (CGPoint)positionForTimeProgress:(CGFloat)progress withControlPoints:(NSArray *)points;

@end


@interface KLLinearPathFunction : NSObject <KLPathFunction>

@end


@interface KLBezierPathFunction : NSObject <KLPathFunction>

@end
