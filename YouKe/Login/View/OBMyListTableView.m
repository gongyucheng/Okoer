//
//  OBMyListTableView.m
//  YouKe
//
//  Created by obally on 16/1/6.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBMyListTableView.h"
#import "OBMyListCell.h"
#import "OBMyListModel.h"
#import "OBProductListViewController.h"
#import "OBAlertView.h"
@implementation OBMyListTableView

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBMyListModel *myListModel;
    if (self.dataList.count > indexPath.row) {
        myListModel = self.dataList[indexPath.row];
    }
    OBMyListCell *listCell = [OBMyListCell cellWithTableView:tableView];
    listCell.listModel = myListModel;
    return listCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(90);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBMyListModel *myListModel;
    OBMyListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.dataList.count > indexPath.row) {
        myListModel = self.dataList[indexPath.row];
        OBProductListViewController *listVC = [[OBProductListViewController alloc]init];
        listVC.complitionBlock = ^{
            myListModel.product_count = myListModel.product_count - 1;
            cell.listModel = myListModel;
            
        };
        listVC.lid = myListModel.lid;
        listVC.listName = myListModel.name;
        [self.navController pushViewController:listVC animated:YES];
    }
//    OBAlertView *alertView = [[OBAlertView alloc]initAlertViewWithTitle:@"确认将该商品移除清单吗？" cancelButtonTitle:@"取消" otherButtonTitle:@"移除"];
//    [alertView show];
}


@end
