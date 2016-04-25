//
//  OBGradeTableView.m
//  YouKe
//
//  Created by obally on 15/8/14.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBGradeTableView.h"
#import "OBGrandCell.h"
#import "OBProductDetailController.h"
#import "OBGradeModel.h"

@implementation OBGradeTableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBGrandCell *kwCell = [OBGrandCell cellWithTableView:tableView];
    if (self.dataList.count > indexPath.row) {
         kwCell.listModel = self.dataList[indexPath.row];
    }
   
//    kwCell.isRecomendCell = NO;
    return kwCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(140) + KViewHeight(40);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBProductDetailController *pd = [[OBProductDetailController alloc]init];
    OBGradeModel *model = self.dataList[indexPath.row];
    pd.rid = model.rid;
    pd.pid = model.pid;
    [self.navController pushViewController:pd animated:YES];
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}
- (void)deselect
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
}
@end
