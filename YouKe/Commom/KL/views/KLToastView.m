//
//  KLToastView.m
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import "KLToastView.h"

@implementation KLToastView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _toastColor = [UIColor colorWithWhite:0 alpha:0.8];
        _msgFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        _msgColor = [UIColor colorWithWhite:1 alpha:1];
        _msgInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        _msgLineBreakMode = NSLineBreakByWordWrapping;
        _msgAlignment = NSTextAlignmentCenter;
        
        _cornerRadius = 5;
        _showShadow = YES;
        _shadowWidth = 4;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat sw = _showShadow ? _shadowWidth : 0; // shadow width
    CGRect ds = CGRectInset(rect, sw, sw); // display rect
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    {
        CGFloat r = _cornerRadius; // corner radius
        CGFloat x = ds.origin.x;
        CGFloat y = ds.origin.y;
        CGFloat w = ds.size.width;
        CGFloat h = ds.size.height;
        
        [_toastColor setFill];
//        [[UIColor clearColor] setStroke];
        
        if (_showShadow) {
            if (_shadowColor)
                CGContextSetShadowWithColor(context, _shadowOffset, sw, _shadowColor.CGColor);
            else
                CGContextSetShadow(context, _shadowOffset, sw);
        }
        
        CGContextMoveToPoint(context, x + r, y);
        
        CGContextAddLineToPoint(context, x + w - r, y);
        CGContextAddArc(context, x + w - r, y + r, r, -M_PI_2, 0.0, 0);
        
        CGContextAddLineToPoint(context, x + w, y + h - r);
        CGContextAddArc(context, x + w - r, y + h - r, r, 0.0, M_PI_2, 0);
        
        CGContextAddLineToPoint(context, x + r, y + h);
        CGContextAddArc(context, x + r, y + h - r, r, M_PI_2, M_PI, 0);
        
        CGContextAddLineToPoint(context, x, y + r);
        CGContextAddArc(context, x + r, y + r, r, M_PI, M_PI + M_PI_2, 0);
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
    }
    
    {
        if (_msgText.length > 0) {
            CGRect mr = UIEdgeInsetsInsetRect(ds, _msgInsets);
            
            [_msgColor set];
            [_msgText drawInRect:mr withFont:_msgFont  lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];

        }
    }
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize bs = size;
    CGFloat sw = _showShadow ? _shadowWidth : 0;
    bs.height -= _msgInsets.top + _msgInsets.bottom + sw * 2;
    bs.width -= _msgInsets.left + _msgInsets.right + sw * 2;
    CGSize ms = [_msgText sizeWithFont:_msgFont constrainedToSize:bs lineBreakMode:_msgLineBreakMode];
    return CGSizeMake(ms.width + _msgInsets.left + _msgInsets.right + sw * 2, ms.height + _msgInsets.top + _msgInsets.bottom + sw * 2);
}

@end
