//
//  OBColorRefresh.h
//  RefreshDemo
//
//  Created by obally on 15/8/7.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OBRefreshTableHeaderDelegate;
@interface OBColorRefresh : UIView

/**
 *  colorArray 背景颜色数组 数组传三色值
 */
@property (nonatomic, retain) NSArray *colorArray;
@property(nonatomic,assign) id <OBRefreshTableHeaderDelegate> delegate;
- (void)obRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)stop;
- (void)start;
@property(nonatomic,assign)BOOL hided;

@end
@protocol OBRefreshTableHeaderDelegate
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(OBColorRefresh*)view;
- (void)egoRefreshTableHeaderDidTriggerRefresh:(OBColorRefresh*)view;
@end