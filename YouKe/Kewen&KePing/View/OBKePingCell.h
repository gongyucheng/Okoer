//
//  OBRecommendCell.h
//  YouKe
//
//  Created by obally on 15/7/29.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBKPListModel.h"
@protocol OBKPCellDelegate <NSObject>
@optional
//- (void)didSelectedLoveButtonWithSelected:(BOOL)isSelected;
- (void)didSelectedKPChatButtonWithListModel:(OBKPListModel *)listModel;
- (void)didSelectedKPCommentButtonWithListModel:(OBKPListModel *)listModel;
- (void)didSelectedKPMoreButtonWithListModel:(OBKPListModel *)listModel;
@end

@interface OBKePingCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,assign)id<OBKPCellDelegate> kpDelegate;
@property(nonatomic,assign)BOOL isRecomendCell;
@property (nonatomic, retain) OBKPListModel *listModel;
@end
