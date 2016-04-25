//
//  OBKeWenCell.h
//  YouKe
//
//  Created by obally on 15/7/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBKWListModel.h"
@protocol OBKWCellDelegate <NSObject>
@optional
- (void)didSelectedKWCommentButtonWithListModel:(OBKWListModel *)listModel;
- (void)didSelectedKWMoreButtonWithListModel:(OBKWListModel *)listModel;
@end

@interface OBKeWenCell : UITableViewCell
@property(nonatomic,assign)id<OBKWCellDelegate> kwDelegate;
@property (nonatomic, retain) OBKWListModel *listModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,assign)BOOL isRecomendCell;
@end
