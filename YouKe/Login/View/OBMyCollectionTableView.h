//
//  OBMyCollectionTableView.h
//  YouKe
//
//  Created by obally on 15/8/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
@interface OBMyCollectionTableView :BaseTableView
@property (nonatomic, retain) NSArray *dataList;
@property(nonatomic,assign)BOOL isSearch;
@end
