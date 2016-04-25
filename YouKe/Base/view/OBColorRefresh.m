//
//  OBColorRefresh.m
//  RefreshDemo
//
//  Created by obally on 15/8/7.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBColorRefresh.h"
#import "UIViewExt.h"
// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define HWRandomColor HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//获取物理屏幕的尺寸
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@implementation OBColorRefresh
{
    CGRect rectMark1;//标记第一个位置
    CGRect rectMark2;//标记第二个位置
    
    NSMutableArray* viewArr;
    
    NSTimeInterval timeInterval;//时间
    
    BOOL isStop;//停止
    BOOL isAlreadyStart;
//    id _delegate;

}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self initView];
         NSString *string = [[UIDevice currentDevice] name];
        NSLog(@"%@",string);
        
    }
    
    return self;
    
}

- (void)initView
{
    if (!self.colorArray) {
        self.colorArray = @[HWColor(26, 138, 71),HWColor(90, 207, 56),HWColor(166, 206, 57),HWColor(238, 232, 8),HWColor(255, 294, 14),HWColor(243, 112, 33)];        
    }
    rectMark1 = CGRectMake(-kScreenWidth, 0, kScreenWidth, self.height);
    rectMark2 = CGRectMake(0, 0, kScreenWidth, self.height);;
    
    UIView *view1 = [self createColorViewWithFrame:rectMark1];
    UIView *view2 = [self createColorViewWithFrame:rectMark2];
    
    [self addSubview:view2];
    [self addSubview:view1];
     viewArr = [NSMutableArray arrayWithObject:view1];
    [viewArr addObject:view2];
//    [self paomaAnimate];
    
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
        //        [self addSubview:label];
        //        [view1 addSubview:label];
        [view addSubview:label];
    }
    return view;
}

- (void)paomaAnimate{
    
    if (!isStop) {
        //
        UIView* lbindex0 = viewArr[0];
        UIView* lbindex1 = viewArr[1];
        
        [UIView transitionWithView:self duration:3 options:UIViewAnimationOptionCurveLinear animations:^{
            //
            
            lbindex0.frame = CGRectMake(0, 0, kScreenWidth,self.height);
            lbindex1.frame = CGRectMake(kScreenWidth, 0, kScreenWidth,self.height);
            
        } completion:^(BOOL finished) {
            //
            
            lbindex0.frame = rectMark2;
            lbindex1.frame = rectMark1;
            
            [viewArr replaceObjectAtIndex:0 withObject:lbindex1];
            [viewArr replaceObjectAtIndex:1 withObject:lbindex0];
            
            [self paomaAnimate];
        }];
    }
}

- (void)start{
    if (!isAlreadyStart) {
        isAlreadyStart = YES;
        isStop = NO;
        UILabel* lbindex0 = viewArr[0];
        UILabel* lbindex1 = viewArr[1];
        lbindex0.frame = rectMark2;
        lbindex1.frame = rectMark1;
        
        [viewArr replaceObjectAtIndex:0 withObject:lbindex1];
        [viewArr replaceObjectAtIndex:1 withObject:lbindex0];
        
        [self paomaAnimate];
        NSLog(@"--------OBColorstart-------------------------");
    }
    
    
}
- (void)stop{
    isStop = YES;
    isAlreadyStart = NO;
}
- (void)obRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
        
//        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
//            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
//        }
//        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        
    }

}
- (void)setHided:(BOOL)hided
{
    if (hided) {
        self.hidden = YES;
    } else
        self.hidden = NO;
}
@end
