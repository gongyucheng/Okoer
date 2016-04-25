//
//  OBKePingTableView.m
//  YouKe
//
//  Created by obally on 15/8/4.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKePingTableView.h"
#import "OBKePingCell.h"
#import "OBKPDetailViewController.h"
#import "OBKPListModel.h"
#import "OBCommentViewController.h"
#import "OBOKOerLoginViewController.h"
#import "OBChatRoomController.h"

@interface OBKePingTableView()<OBKPCellDelegate>

@end
@implementation OBKePingTableView

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBKePingCell *kwCell = [OBKePingCell cellWithTableView:tableView];
    if (self.dataList.count > indexPath.row) {
        kwCell.listModel = self.dataList[indexPath.row];
    }
    kwCell.isRecomendCell = NO;
    kwCell.kpDelegate = self;
    return kwCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(480);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBKPDetailViewController *kpd = [[OBKPDetailViewController alloc]init];
    if (self.dataList.count > indexPath.row) {
        OBKPListModel *model = self.dataList[indexPath.row];
        kpd.pageId = model.nid;
    }
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:kwd];
    [self.kewenAndKePingController.navigationController pushViewController:kpd animated:YES];
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
}
#pragma mark-
- (void)didSelectedKPMoreButtonWithListModel:(OBKPListModel *)listModel
{
    if ([self.kpTableViewDelegate respondsToSelector:@selector(tableViewdidSelectedMoreButtonWithListModel:)]) {
        [self.kpTableViewDelegate tableViewdidSelectedMoreButtonWithListModel:listModel];
    }

}

- (void)didSelectedKPCommentButtonWithListModel:(OBKPListModel *)listModel
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = listModel.nid;
    commentVC.commentTitle = listModel.title;
    [self.kewenAndKePingController.navigationController pushViewController:commentVC animated:YES];
}
- (void)didSelectedKPChatButtonWithListModel:(OBKPListModel *)listModel
{
    OBChatRoomController *chatVC = [[OBChatRoomController alloc]init];
    chatVC.chatId = listModel.nid;
    chatVC.roomtitle = listModel.title;
    [self.kewenAndKePingController.navigationController pushViewController:chatVC animated:YES];
//    [self.kewenAndLePingController presentViewController:chatVC animated:YES completion:nil];
}
@end
