//
//  OBAddListTableView.h
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "BaseTableView.h"

@protocol OBAddListTableViewDelegate <NSObject>
@optional
- (void)didSelectedAddListTableViewWithIndexPath:(NSIndexPath *)indexpath;
@end
@interface OBAddListTableView : BaseTableView
@property (nonatomic, retain) NSMutableArray *listArrays;
//@property(nonatomic,assign)BOOL haveInsert;
@property(nonatomic,assign)id<OBAddListTableViewDelegate> addListTableViewDelegate;
//@property(nonatomic,assign)NSInteger number;
@end
