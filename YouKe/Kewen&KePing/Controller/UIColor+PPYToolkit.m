//
//  UIColor+PPYToolkit.m
//  SuperCal
//
//  Created by Hale Chan on 14-6-30.
//  Copyright (c) 2014年 Beijing PapayaMobile Inc. All rights reserved.
//

#import "UIColor+PPYToolkit.h"

@implementation UIColor(PPYToolkit)

+ (UIColor *)colorWithARGB:(u_int32_t)argb
{
    return [UIColor colorWithRed:((argb&0xff0000)>>16)/255.0 green:((argb&0xff00)>>8)/255.0 blue:(argb&0xff)/255.0 alpha:(argb>>24)/255.0];
}

+ (UIColor *)colorWithRGB:(u_int32_t)rgb alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(rgb>>16)/255.0 green:((rgb&0x00ff00)>>8)/255.0 blue:(rgb&0x0000FF)/255.0 alpha:alpha];
}

+ (UIColor *)colorWithRGBA:(u_int32_t)rgba
{
    return [UIColor colorWithRed:(rgba>>24)/255.0 green:((rgba&0xff0000)>>16)/255.0 blue:((rgba&0xff00)>>8)/255.0 alpha:(rgba&0xff)/255.0];
}

+ (UIColor *)colorWithRGB:(u_int32_t)rgb
{
    return [UIColor colorWithRed:((rgb&0xff0000)>>16)/255.0 green:((rgb&0xff00)>>8)/255.0 blue:(rgb&0xff)/255.0 alpha:1.0];
}

@end
