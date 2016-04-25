//
//  OBCollectionCell.h
//  YouKe
//
//  Created by obally on 15/8/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBMyCollectionModel.h"
@interface OBCollectionCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, retain) OBMyCollectionModel *listModel;
@property(nonatomic,assign)BOOL isKW;
@end
