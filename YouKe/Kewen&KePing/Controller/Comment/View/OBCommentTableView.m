//
//  OBCommentTableView.m
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBCommentTableView.h"
#import "OBCommentCell.h"
#import "OBReplyView.h"

@interface OBCommentTableView ()

@end
@implementation OBCommentTableView
//
//- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
//{
//    self = [super initWithFrame:frame style:style];
//    if (self) {
//        // Initialization code
//        
//        //去掉背景颜色
//        self.backgroundColor = [UIColor clearColor];
//        self.backgroundView = nil;
//        
//        //去掉分割线
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.rowHeight = KViewHeight(480);
//        
//        //设置代理对象
//        self.dataSource = self;
//        self.delegate = self;
//        
//    }
//    return self;
//}

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBCommentCell *cmCell = [OBCommentCell cellWithTableView:tableView];
//    kwCell.kwDelegate = self;
    if (self.dataList.count > indexPath.row) {
        cmCell.commentFrame = self.dataList[indexPath.row];
    }
    
//    cmCell.isRecomendCell = NO;
    return cmCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList.count > indexPath.row) {
        OBCommentFrame *frame = self.dataList[indexPath.row];
        return frame.originalViewF.size.height;
    } else
        return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commentTabelViewDelegate && [self.commentTabelViewDelegate respondsToSelector:@selector(didSelectedCellWithIndexPath:)]) {
        [self.commentTabelViewDelegate didSelectedCellWithIndexPath:indexPath];
    }
   
}



@end
