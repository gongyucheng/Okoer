//
//  OBKePingTableView.h
//  YouKe
//
//  Created by obally on 15/8/4.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "BaseTableView.h"
@class OBKPListModel;
@protocol OBKePingTableViewDelegate <NSObject>
@optional
- (void)tableViewdidSelectedMoreButtonWithListModel:(OBKPListModel *)listModel;
@end

@interface OBKePingTableView : BaseTableView
@property(nonatomic,assign)id<OBKePingTableViewDelegate> kpTableViewDelegate;
@property (nonatomic, retain) NSArray *dataList;
@end
