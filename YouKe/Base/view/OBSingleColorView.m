//
//  OBSingleColorView.m
//  YouKe
//
//  Created by obally on 15/8/15.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBSingleColorView.h"

@implementation OBSingleColorView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self initView];
        
    }
    
    return self;
    
}
- (void)initView
{
    if (!self.colorArray) {
        self.colorArray = @[HWColor(26, 138, 71),HWColor(90, 207, 56),HWColor(166, 206, 57),HWColor(238, 232, 8),HWColor(255, 294, 14),HWColor(243, 112, 33)];
    }
    
    UIView *view1 = [self createColorViewWithFrame:self.frame];
    [self addSubview:view1];
}

- (UIView *)createColorViewWithFrame:(CGRect)rect
{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    if (!self.colorArray) {
        self.colorArray = @[HWColor(26, 138, 71),HWColor(90, 207, 56),HWColor(166, 206, 57),HWColor(238, 232, 8),HWColor(255, 294, 14),HWColor(243, 112, 33)];
    }
    for (int i = 0; i < self.colorArray.count; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/self.colorArray.count * i, 0, kScreenWidth/self.colorArray.count, self.height)];
        label.backgroundColor = self.colorArray[i];
        [view addSubview:label];
    }
    return view;
}

@end
