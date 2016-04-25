//
//  OBKeWenTableView.h
//  YouKe
//
//  Created by obally on 15/8/4.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "BaseTableView.h"
@class OBKWListModel;
@protocol OBKeWenTableViewDelegate <NSObject>
@optional
- (void)tableViewdidSelectedMoreButtonWithListModel:(OBKWListModel *)listModel;
@end

@interface OBKeWenTableView : BaseTableView
@property(nonatomic,assign)id<OBKeWenTableViewDelegate> kwTableViewDelegate;
@property (nonatomic, retain) NSArray *dataList;
@end
