//
//  OBBrandTableView.m
//  YouKe
//
//  Created by obally on 15/8/14.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBBrandTableView.h"
#import "OBBrandCell.h"
@implementation OBBrandTableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBBrandCell *kwCell = [OBBrandCell cellWithTableView:tableView];
    if (self.dataList.count > 0) {
        kwCell.brandModels = self.dataList[indexPath.row];
    }
    
    //    kwCell.isRecomendCell = NO;
    return kwCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(140);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    OBKWDetailViewController *kwd = [[OBKWDetailViewController alloc]init];
    //    OBKWListModel *model = self.dataList[indexPath.row];
    //    kwd.pageId = model.nid;
    //    [self.containerViewController presentViewController:kwd animated:NO completion:nil];
}

@end
