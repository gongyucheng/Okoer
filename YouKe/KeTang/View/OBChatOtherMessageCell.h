//
//  OBChatOtherMessageCell.h
//  YouKe
//
//  Created by obally on 15/8/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBChatMessageFrame.h"

@interface OBChatOtherMessageCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, retain) OBChatMessageFrame *messageFrame;
//@property(nonatomic,assign)BOOL showTimeLabel;
@end
