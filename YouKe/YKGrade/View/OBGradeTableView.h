//
//  OBGradeTableView.h
//  YouKe
//
//  Created by obally on 15/8/14.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "BaseTableView.h"

@interface OBGradeTableView : BaseTableView
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, assign) BOOL ispinpaiVc;
@property (nonatomic, assign) BOOL isSearchVC;
@property (nonatomic, assign) BOOL isSingleVC;
@end
