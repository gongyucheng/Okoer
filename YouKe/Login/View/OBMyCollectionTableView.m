//
//  OBMyCollectionTableView.m
//  YouKe
//
//  Created by obally on 15/8/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBMyCollectionTableView.h"
#import "OBCollectionCell.h"
#import "OBMyCollectionModel.h"
#import "OBKPDetailViewController.h"
#import "OBKWDetailViewController.h"

@implementation OBMyCollectionTableView

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBMyCollectionModel *collectionModel;
    if (self.dataList.count > indexPath.row) {
         collectionModel = self.dataList[indexPath.row];
    }
    OBCollectionCell *collectionCell = [OBCollectionCell cellWithTableView:tableView];
    collectionCell.listModel = collectionModel;
    return collectionCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(150);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBMyCollectionModel *collectionModel;
    if (self.dataList.count > indexPath.row) {
        collectionModel = self.dataList[indexPath.row];
    }
    if ([collectionModel.type isEqualToString:@"nr"]) {
        //报告
        OBKPDetailViewController *kpd = [[OBKPDetailViewController alloc]init];
        kpd.pageId = collectionModel.kpModel.nid;
        [self.navController pushViewController:kpd animated:YES];
        
    } else if ([collectionModel.type isEqualToString:@"an"]) {
        //资讯
        OBKWDetailViewController *kwd = [[OBKWDetailViewController alloc]init];
        kwd.pageId = collectionModel.kpModel.nid;
        [self.navController pushViewController:kwd animated:YES];

    }
}

@end
