//
//  OBSlideCell.h
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBSlideCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *subtitleString;
@property (nonatomic, copy) NSString *imageString;
@end
