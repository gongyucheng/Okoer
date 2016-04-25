//
//  OBBrandCell.h
//  YouKe
//
//  Created by obally on 15/8/15.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBBrandModel.h"
@interface OBBrandCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, retain) NSArray *brandModels;
@end
