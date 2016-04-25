//
//  KLBox.m
//  SuperCal
//
//  Created by Lu Ming on 13-9-9.
//  Copyright (c) 2013年 Lu Ming. All rights reserved.
//

#import "KLBox.h"

#define DEFAULT_MARGIN 5

@implementation KLVBox

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.margin = 5;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect frame = rect;
    int count = self.subviews.count;
    CGFloat margin = self.margin;
    
    frame.size.height = (rect.size.height - margin * (count - 1)) / count;
    
    for (UIView *view in self.subviews) {
        view.frame = frame;
        frame.origin.y += margin + frame.size.height;
    }
}

@end



@implementation KLHBox

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.margin = 5;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect frame = rect;
    int count = self.subviews.count;
    CGFloat margin = self.margin;
    
    frame.size.width = (rect.size.width - margin * (count - 1)) / count;
    
    for (UIView *view in self.subviews) {
        view.frame = frame;
        frame.origin.x += margin + frame.size.width;
    }
}

@end
