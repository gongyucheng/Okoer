//
//  KLDialogTitleView.m
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import "KLDialogTitleView.h"
//#import "PPYUIToolkit.h"

@interface KLDialogTitleView ()
@property (nonatomic, assign) CGRect logoFrame;
@property (nonatomic, assign) CGRect titleFrame;
@end



@implementation KLDialogTitleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleAlignment = NSTextAlignmentCenter;
        _titleLineBreakMode = NSLineBreakByTruncatingTail;
        
        _titleColor = [UIColor colorWithWhite:0 alpha:0.8];
        _titleFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
        _titleNumberOfLines = 1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat margin = 10;
    
    if (_logoImage) {
        _logoFrame = rect;
        if (CGSizeEqualToSize(_logoSize, CGSizeZero))
            _logoFrame.size = CGSizeMake(rect.size.height, rect.size.height);
        else
            _logoFrame.size = _logoSize;
        
        _logoFrame.origin.y = (rect.size.height - _logoFrame.size.height) * 0.5;
        _logoFrame.origin.x = _logoFrame.origin.y;
        
        [_logoImage drawInRect:_logoFrame];
    }
    
    if (_titleText.length > 0) {
        _titleFrame = rect;
        _titleFrame.size.width = rect.size.width - _logoFrame.size.width - margin;
        _titleFrame.origin.x = _logoFrame.origin.x * 2 + _logoFrame.size.width + margin;
        
        [_titleColor set];
        [_titleText drawInRect:_titleFrame withFont:_titleFont lineBreakMode:_titleLineBreakMode alignment:_titleAlignment];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize ts = size;
    CGFloat lh = [@"Tg" sizeWithFont:_titleFont].height;
    if (_logoImage)
        ts.width = size.width - lh;
    
    ts = [_titleText sizeWithFont:_titleFont constrainedToSize:ts lineBreakMode:_titleLineBreakMode];
    if (_titleNumberOfLines > 0)
        ts.height = MIN(lh * _titleNumberOfLines, ts.height);
    if (_logoImage)
        ts.height = MAX(lh, ts.height);
    ts.width = size.width;
    
    return ts;
}


@end
