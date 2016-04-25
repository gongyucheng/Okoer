//
//  OBChatMessageTableView.m
//  YouKe
//
//  Created by obally on 15/8/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBChatMessageTableView.h"
#import "OBChatOtherMessageCell.h"
#import "OBChatMessageModel.h"

@interface OBChatMessageTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation OBChatMessageTableView
#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.dataList[indexPath.row] isKindOfClass:[OBChatMessageFrame class]] && indexPath.row == 0) {
        UITableViewCell  *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(10), kScreenWidth - KViewWidth(20), KViewHeight(70))];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:KFont(13.0)];
        label.numberOfLines = 0;
        label.text = self.dataList[0];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        return cell;
    } else if (self.dataList.count > indexPath.row){
        OBChatOtherMessageCell *otherCell = [OBChatOtherMessageCell cellWithTableView:tableView];
         OBChatMessageFrame *currentModel = self.dataList[indexPath.row];
        otherCell.messageFrame = currentModel;
        return otherCell;
    } else
        return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.dataList[indexPath.row] isKindOfClass:[OBChatMessageFrame class]] && indexPath.row == 0) {
        return KViewHeight(90);
    } else {
        OBChatMessageFrame *frame = self.dataList[indexPath.row];
        return frame.originalViewF.size.height;
    }
    
}


@end
