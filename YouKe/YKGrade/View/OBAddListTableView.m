//
//  OBAddListTableView.m
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBAddListTableView.h"
#import "OBMyListModel.h"

@interface OBAddListTableView ()
{
    NSInteger i;
}
@end
@implementation OBAddListTableView

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
//    NSString *CellIdentifier = [NSString stringWithFormat:@"cell %ld",indexPath.row];
//    if (self.haveInsert) {
//        CellIdentifier = [NSString stringWithFormat:@"cell %ld",indexPath.row - self.number];
////        self.haveInsert = NO;
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, KViewHeight(49))];
        button.tag = 100;
        button.userInteractionEnabled = NO;
        //        button.backgroundColor = HWRandomColor;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0,KViewWidth(20), 0,KViewWidth(50))];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, KViewWidth(30), 0, 0)];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
        button.selected = NO;
        [button setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(50) - KViewHeight(1), kScreenWidth - KViewWidth(10) * 2, KViewHeight(1))];
        label.backgroundColor = [UIColor whiteColor];
        label.tag = 101;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:button];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (self.listArrays.count > indexPath.row) {
        OBMyListModel *listModel = self.listArrays[indexPath.row];
        UIButton *button = (UIButton *)[cell viewWithTag:100];
        [button setTitle:listModel.name forState:UIControlStateNormal];
        button.selected = listModel.isSelected;
        UILabel *label = (UILabel *)[cell viewWithTag:101];
//        button.selected = button.selected;
        if (indexPath.row == self.listArrays.count - 1) {
            label.hidden = YES;
        } else
            label.hidden = NO;
    }
    [self layoutIfNeeded];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(50);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.listArrays.count > indexPath.row) {
        if (self.addListTableViewDelegate && [self.addListTableViewDelegate respondsToSelector:@selector(didSelectedAddListTableViewWithIndexPath:)]) {
            [self.addListTableViewDelegate didSelectedAddListTableViewWithIndexPath:indexPath];
        }

    }
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
