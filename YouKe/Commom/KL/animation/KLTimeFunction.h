//
//  KLTimeFunction.h
//  SuperCal
//
//  Created by Lu Ming on 13-9-11.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLTimeFunction

- (CGFloat)progressForTimeProgress:(CGFloat)progress;

@end


// simple linear tweening - no easing, no acceleration
@interface KLLinearTimeFunction : NSObject <KLTimeFunction>

@end

// quadratic easing in - accelerating from zero velocity
@interface KLEaseInTimeFunction : NSObject <KLTimeFunction>

@end

// quadratic easing out - decelerating to zero velocity
@interface KLEaseOutTimeFunction : NSObject <KLTimeFunction>

@end

// quadratic easing in/out - acceleration until halfway, then deceleration
@interface KLEaseInEaseOutTimeFunction : NSObject <KLTimeFunction>

@end
