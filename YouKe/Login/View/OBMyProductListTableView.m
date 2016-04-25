//
//  OBMyProductListTableView.m
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBMyProductListTableView.h"
#import "OBGradeModel.h"
#import "OBMyProductListCell.h"
#import "OBProductDetailController.h"
@interface OBMyProductListTableView ()<OBMyProductListCellDelegate>

@end
@implementation OBMyProductListTableView

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBGradeModel *myGradeModel;
    if (self.dataList.count > indexPath.row) {
        myGradeModel = self.dataList[indexPath.row];
    }
    OBMyProductListCell *listCell = [OBMyProductListCell cellWithTableView:tableView];
    listCell.productCellDelegate = self;
    listCell.listModel = myGradeModel;
    return listCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(140) + KViewHeight(40);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBProductDetailController *pd = [[OBProductDetailController alloc]init];
    OBGradeModel *model = self.dataList[indexPath.row];
    pd.pid = model.rid;
    [self.navController pushViewController:pd animated:YES];
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}
- (void)deselect
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
}
#pragma mark - OBMyProductListCellDelegate
- (void)myProductListCellDidSelectedRemoveButtonWithGradeModel:(OBGradeModel *)gradeModel
{
    if (self.productTableDelegate && [self.productTableDelegate respondsToSelector:@selector(myProductListTableViewDidSelectedRemoveButtonWithGradeModel:)]) {
        [self.productTableDelegate myProductListTableViewDidSelectedRemoveButtonWithGradeModel:gradeModel];
    }
}

@end
