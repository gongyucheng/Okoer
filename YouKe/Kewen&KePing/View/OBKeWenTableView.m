//
//  OBKeWenTableView.m
//  YouKe
//
//  Created by obally on 15/8/4.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKeWenTableView.h"
#import "OBKeWenCell.h"
#import "OBKWDetailViewController.h"
#import "OBKWListModel.h"
#import "OBCommentViewController.h"
#import "OBOKOerLoginViewController.h"

@interface OBKeWenTableView()<OBKWCellDelegate>

@end
@implementation OBKeWenTableView

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBKeWenCell *kwCell = [OBKeWenCell cellWithTableView:tableView];
    kwCell.kwDelegate = self;
    if (self.dataList.count > indexPath.row) {
         kwCell.listModel = self.dataList[indexPath.row];
    }
   
    kwCell.isRecomendCell = NO;
    return kwCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(480);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBKWDetailViewController *kwd = [[OBKWDetailViewController alloc]init];
    if (self.dataList.count > indexPath.row) {
        OBKWListModel *model = self.dataList[indexPath.row];
        kwd.pageId = model.nid;
    }
    [self.kewenAndKePingController.navigationController pushViewController:kwd animated:YES];
//    [self.containerViewController presentViewController:kwd animated:NO completion:nil];
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
}

#pragma mark-
-(void)didSelectedKWMoreButtonWithListModel:(OBKWListModel *)listModel
{
    if ([self.kwTableViewDelegate respondsToSelector:@selector(tableViewdidSelectedMoreButtonWithListModel:)]) {
        [self.kwTableViewDelegate tableViewdidSelectedMoreButtonWithListModel:listModel];
    }
}
- (void)didSelectedKWCommentButtonWithListModel:(OBKWListModel *)listModel
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = listModel.nid;
    commentVC.commentTitle = listModel.title;
    [self.kewenAndKePingController.navigationController pushViewController:commentVC animated:YES];
//    [self.containerViewController presentViewController:commentVC animated:YES completion:nil];
   
}

@end
