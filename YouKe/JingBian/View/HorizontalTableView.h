//
//  HorizontalTableView.h
//  WXMovie
//
//  Created by zsm on 14-4-14.
//  Copyright (c) 2014年 zsm. All rights reserved.
//
//  水平方向表视图的基类

#import <UIKit/UIKit.h>
@class OBKWListModel;
@class OBKPListModel;
//extern CGFloat const RowHeight;
typedef void (^IndexBlock)(NSInteger index);
@protocol OBHorizontalTableViewDelegate <NSObject>
@optional
- (void)tableViewdidSelectedKWMoreButtonWithListModel:(OBKWListModel *)listModel;
- (void)tableViewdidSelectedKPMoreButtonWithListModel:(OBKPListModel *)listModel;
@end
@interface HorizontalTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)id<OBHorizontalTableViewDelegate> horizonTableViewDelegate;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,retain)NSMutableArray *dataList;
@property(nonatomic,copy)IndexBlock block;
@end
