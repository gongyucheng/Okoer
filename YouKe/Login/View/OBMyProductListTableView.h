//
//  OBMyProductListTableView.h
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "BaseTableView.h"
@class OBGradeModel;
@protocol OBMyProductListTableViewDelegate <NSObject>

@optional
- (void)myProductListTableViewDidSelectedRemoveButtonWithGradeModel:(OBGradeModel *)gradeModel;

@end

@interface OBMyProductListTableView : BaseTableView
@property (nonatomic, retain) NSMutableArray *dataList;
@property(nonatomic,assign)id<OBMyProductListTableViewDelegate> productTableDelegate;
@end
