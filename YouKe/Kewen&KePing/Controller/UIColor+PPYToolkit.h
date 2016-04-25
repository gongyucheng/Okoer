//
//  UIColor+PPYToolkit.h
//  SuperCal
//
//  Created by Hale Chan on 14-6-30.
//  Copyright (c) 2014年 Beijing PapayaMobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(PPYToolkit)
+ (UIColor *)colorWithARGB:(u_int32_t)argb;
+ (UIColor *)colorWithRGB:(u_int32_t)rgb alpha:(CGFloat)alpha;
+ (UIColor *)colorWithRGBA:(u_int32_t)rgba;
+ (UIColor *)colorWithRGB:(u_int32_t)rgb;
@end
