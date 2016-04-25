//
//  OBCommentCell.h
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBCommentFrame.h"
@interface OBCommentCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, retain) OBCommentFrame *commentFrame;
@end
