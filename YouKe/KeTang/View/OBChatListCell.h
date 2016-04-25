//
//  OBChatListCell.h
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBChatListModel.h"
#import "OBChatMessageModel.h"

@interface OBChatListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, retain) OBChatListModel *listModel;
@property (nonatomic, retain) OBChatMessageModel *messageModel;
@end
