//
//  OBChatTableView.m
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBChatTableView.h"
#import "OBChatListCell.h"
#import "OBChatRoomController.h"
#import "OBChatListModel.h"

@implementation OBChatTableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBChatListCell *chatCell = [OBChatListCell cellWithTableView:tableView];
    if (self.dataList.count > indexPath.row) {
        chatCell.listModel = self.dataList[indexPath.row];
    }
    //    kwCell.isRecomendCell = NO;
    return chatCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(200);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBChatRoomController *chatVC = [[OBChatRoomController alloc]init];
    OBChatListCell *cell = (OBChatListCell *)[tableView cellForRowAtIndexPath:indexPath];
    chatVC.chatMessageblock =  ^(OBChatMessageFrame *messageFrame) {
//        cell.messageModel = messageFrame.chatModel;
    };
    if (self.dataList.count > indexPath.row) {
        OBChatListModel *model = self.dataList[indexPath.row];
        chatVC.chatId = model.nid;
        chatVC.roomtitle = model.title;
    }
    [self.containerViewController presentViewController:chatVC animated:NO completion:nil];
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
}

@end
