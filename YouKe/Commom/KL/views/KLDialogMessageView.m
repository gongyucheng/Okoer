//
//  KLDialogMessageView.m
//  TestKL
//
//  Created by Lu Ming on 13-6-2.
//  Copyright (c) 2013年 KL. All rights reserved.
//

#import "KLDialogMessageView.h"
//#import "PPYUIToolkit.h"


///---------------------------------------------------------------------------------------------------------------------
@implementation KLDialogMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _customView = nil;
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.lineBreakMode = UILineBreakModeTailTruncation;
        
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.height = [_messageLabel.text sizeWithFont:_messageLabel.font constrainedToSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) lineBreakMode:_messageLabel.lineBreakMode].height;
    [_messageLabel setFrame:rect];
    
    if (_customView) {
        _customView.width = rect.size.width;
        if (_customView.height == 0) {
            [_customView sizeToFit];
        }
        _customView.top = _messageLabel.bottom;
        _customView.centerX = CGRectGetMidX(self.bounds);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize ms = [_messageLabel.text sizeWithFont:_messageLabel.font constrainedToSize:size lineBreakMode:_messageLabel.lineBreakMode];
    CGSize cs = CGSizeZero;
    if (_customView.height == 0)
        cs = [_customView sizeThatFits:size];
    else
        cs = _customView.size;
    
    CGSize ns = CGSizeMake(size.width, ms.height + cs.height);
    ns.height = MIN(ns.height, size.height);
    return ns;
}

- (void)setCustomView:(UIView *)customView{
    if (_customView == customView)
        return;
    
    [_customView removeFromSuperview];
    _customView = customView;
    [self addSubview:_customView];
    [self setNeedsLayout];
}

@end
