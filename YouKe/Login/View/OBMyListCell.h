//
//  OBMyListCell.h
//  YouKe
//
//  Created by obally on 16/1/6.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OBMyListModel;
@interface OBMyListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, retain) OBMyListModel *listModel;
@end
