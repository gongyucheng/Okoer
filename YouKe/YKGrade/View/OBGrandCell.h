//
//  OBGrandCell.h
//  YouKe
//
//  Created by obally on 15/8/14.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradeModel.h"

@interface OBGrandCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, retain) OBGradeModel *listModel;
//@property(nonatomic,assign)id<OBGrandCellDelegate> gradeCellDelegate;
@end
