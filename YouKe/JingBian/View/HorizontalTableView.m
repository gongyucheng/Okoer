//
//  HorizontalTableView.m
//  WXMovie
//
//  Created by zsm on 14-4-14.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "HorizontalTableView.h"
#import "OBKeWenCell.h"
#import "OBKePingCell.h"
#import "OBColorRefresh.h"
#import "OBRecommendModel.h"
#import "OBKWDetailViewController.h"
#import "OBKPDetailViewController.h"
#import "OBCommentViewController.h"
#import "OBChatRoomController.h"
#import "OBOKOerLoginViewController.h"

//CGFloat const RowHeight = KViewHeight(480);
@interface HorizontalTableView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,OBKPCellDelegate,OBKWCellDelegate>

@end
@implementation HorizontalTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        
        //去掉背景颜色
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        //逆时针旋转90度
        self.transform = CGAffineTransformMakeRotation(-M_PI);
        
        //重新设定当前的frame
        self.frame = frame;
        
        //去掉滑动指示器
        self.showsVerticalScrollIndicator = NO;
        
        //去掉分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //开启快速减速
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        //获取表示图的滑动手势
//        self.panGestureRecognizer.delegate = self;
        self.rowHeight = KViewHeight(480);
       
        //设置代理对象
        self.dataSource = self;
        self.delegate = self;

    }
    return self;
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBRecommendModel *recommendModel;
    if (self.dataList.count > indexPath.row) {
         recommendModel = self.dataList[indexPath.row];
    }
    
    if ([recommendModel.type isEqualToString:@"nr"]) {
        //恪评
        OBKePingCell *kpCell = [OBKePingCell cellWithTableView:tableView];
        //创转单元格内容视图
        kpCell.contentView.transform = CGAffineTransformMakeRotation(M_PI);
        kpCell.listModel = recommendModel.kpModel;
        kpCell.kpDelegate = self;
        kpCell.isRecomendCell = YES;
        return kpCell;
        
    } else if ([recommendModel.type isEqualToString:@"an"]) {
        //资讯
        OBKeWenCell *kwCell = [OBKeWenCell cellWithTableView:tableView];
        //创转单元格内容视图
        kwCell.contentView.transform = CGAffineTransformMakeRotation(M_PI);
        kwCell.listModel = recommendModel.kwModel;
        kwCell.kwDelegate = self;
        kwCell.isRecomendCell = YES;
        return kwCell;
    }else
        return nil;
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.rowHeight)];
    UIImageView *centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - KViewWidth(48),20, KViewWidth(48), KViewHeight(48))];
    [imageView addSubview:centerImage];
    centerImage.image = [UIImage imageNamed:@"icon_0008_down48"];
    centerImage.backgroundColor = HWRandomColor;
    imageView.backgroundColor = HWRandomColor;
    return imageView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBRecommendModel *recommendModel;
    if (self.dataList.count > indexPath.row) {
        recommendModel = self.dataList[indexPath.row];
    }
    if ([recommendModel.type isEqualToString:@"nr"]) {
        //恪评
        OBKPDetailViewController *kpd = [[OBKPDetailViewController alloc]init];
        kpd.pageId = recommendModel.kpModel.nid;
        [self.recommendController presentViewController:kpd animated:NO completion:nil];
        
    } else if ([recommendModel.type isEqualToString:@"an"]) {
        //资讯
        OBKWDetailViewController *kwd = [[OBKWDetailViewController alloc]init];
        kwd.pageId = recommendModel.kwModel.nid;
        [self.recommendController presentViewController:kwd animated:NO completion:nil];
    }
   
}

#pragma mark - UIScrollView Delegate
//滑动视图时时－>调用的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    OBLog(@"scrollView.contentOffset.y = %f",scrollView.contentOffset.y);
    
   
}

// -----------------新的滑动效果方法------------------------
//将要离开的时候调用的协议方法
//将要离开的时候调用的协议方法 self.pagingEnable = NO;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    //    CGPoint point = CGPointMake(0, 10);
    //    OBLog(@"velocity:%@",NSStringFromCGPoint(velocity));
    
    if ([scrollView isMemberOfClass:[self class]]) {
        //当前在中间的单元格
        NSInteger row_index = (scrollView.contentOffset.y + self.rowHeight / 2.0)  / self.rowHeight;
        
        if (velocity.y == 0 || (row_index == self.dataList.count - 1 && velocity.y > 0) || (row_index == 0 && velocity.y < 0)) {
        }else if (velocity.y > 0) {
            row_index++;
        } else {
            row_index--;
        }
        
        //做了一个限制，向左或者向右最多滑动一个位置
        row_index = row_index - self.index > 1 ? self.index + 1 : row_index;
        row_index = self.index - row_index > 1 ? self.index - 1 : row_index;
        
        //如果滑动为视图不是原来的视图我们就缩小到原来的比例
        if (self.index != row_index) {
            //获取当前单元格里面的滑动视图
//            UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]];
//            UIScrollView *subScrollView = (UIScrollView *)[cell.contentView viewWithTag:123];
//            [subScrollView setZoomScale:1.0 animated:YES];
            self.index = row_index;
        }
        
        //滑动到指定位置
        targetContentOffset->y = self.rowHeight *row_index;
        self.block(self.index + 1);
    }
    
}

#pragma mark - UIGestureRecognizer Delegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

#pragma mark - OBKWCellDelegate

- (void)didSelectedKWMoreButtonWithListModel:(OBKWListModel *)listModel
{
    if ([self.horizonTableViewDelegate respondsToSelector:@selector(tableViewdidSelectedKWMoreButtonWithListModel:)]) {
        [self.horizonTableViewDelegate tableViewdidSelectedKWMoreButtonWithListModel:listModel];
    }
}
- (void)didSelectedKWCommentButtonWithListModel:(OBKWListModel *)listModel
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = listModel.nid;
    commentVC.commentTitle = listModel.title;
    [self.recommendController presentViewController:commentVC animated:YES completion:nil];
}
#pragma mark - OBKPCellDelegate
- (void)didSelectedKPMoreButtonWithListModel:(OBKPListModel *)listModel
{
    if ([self.horizonTableViewDelegate respondsToSelector:@selector(tableViewdidSelectedKPMoreButtonWithListModel:)]) {
        [self.horizonTableViewDelegate tableViewdidSelectedKPMoreButtonWithListModel:listModel];
    }
}
- (void)didSelectedKPChatButtonWithListModel:(OBKPListModel *)listModel
{
    OBChatRoomController *chatVC = [[OBChatRoomController alloc]init];
    chatVC.chatId = listModel.nid;
    chatVC.roomtitle = listModel.title;
    [self.recommendController presentViewController:chatVC animated:YES completion:nil];
}

- (void)didSelectedKPCommentButtonWithListModel:(OBKPListModel *)listModel
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = listModel.nid;
    commentVC.commentTitle = listModel.title;
    [self.recommendController presentViewController:commentVC animated:YES completion:nil];
}



@end
