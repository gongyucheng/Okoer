//
//  BaseTableView.h
//  OBNewCar
//
//  Created by Obally on 14-9-23.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGORefreshTableHeaderView.h"
@class OBColorRefresh;
@class BaseTableView;
@protocol BaseTableViewDelegate <NSObject>

@optional
//下拉刷新
- (void)pullDown:(BaseTableView *)tableView;
//上拉加载
- (void)pullUp:(BaseTableView *)tableView;
@end


@class ThemeButton;
@interface BaseTableView : UITableView<UITableViewDelegate,UITableViewDataSource> {
    
//    OBColorRefresh *_refreshHeaderView;
   
}

//数据
@property(nonatomic,strong)NSArray *data;

//是否显示下拉刷新控件
@property(nonatomic,assign)BOOL refreshHeader;
@property(nonatomic,assign)BOOL refreshFooter;
//是否显示上拉属性
@property(nonatomic,assign)BOOL isLoading;
@property (nonatomic, retain) OBColorRefresh *refreshHeaderView;
@property (nonatomic,retain)UIButton *refreshFooterButton;

@property(nonatomic,retain)id<BaseTableViewDelegate> refreshDelegate;

- (void)setLoadingState;

@end
