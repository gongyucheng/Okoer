//
//  OBCommentTableView.h
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
@protocol OBCommentTableViewDelegate <NSObject>
@optional
- (void)didSelectedCellWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface OBCommentTableView : BaseTableView
@property(nonatomic,assign)id<OBCommentTableViewDelegate> commentTabelViewDelegate;
@property (nonatomic, retain) NSArray *dataList;
@end
