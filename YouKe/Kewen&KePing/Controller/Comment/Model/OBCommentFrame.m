//
//  OBCommentFrame.m
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBCommentFrame.h"

@implementation OBCommentFrame
- (void)setCommentModel:(OBCommentModel *)commentModel
{
    if (_commentModel != commentModel) {
        _commentModel = commentModel;
        [self layoutFrame];
    }
}
- (void)layoutFrame
{
    // cell的宽度
    CGFloat cellW = kScreenWidth;
    /** 头像 */
    CGFloat iconWH = KViewWidth(50);
    CGFloat iconX = HWStatusCellBorderW;
    CGFloat iconY = HWStatusCellBorderW + KViewHeight(5);
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    if (self.isReply) {
        self.iconViewF = CGRectZero;
    }
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HWStatusCellBorderW;
    CGFloat nameY = iconY + KViewHeight(5);
    CGSize nameSize = [_commentModel.name sizeWithFont:HWStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    if (self.isReply) {
        self.nameLabelF = CGRectZero;
    }
    /** 时间 */
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_commentModel.created_time]];
    CGFloat timeY = iconY + KViewHeight(5);
    CGSize timeSize = [currentDateStr sizeWithFont:HWStatusCellNameFont];
    CGFloat timeX = kScreenWidth - timeSize.width - HWStatusCellBorderW;
    self.timelabelF = (CGRect){{timeX, timeY}, timeSize};
    if (self.isReply) {
        self.timelabelF = CGRectZero;
    }
    /** 正文 */
    CGFloat contentX = nameX;
    CGFloat contentY =CGRectGetMaxY(self.nameLabelF) + HWStatusCellBorderW ;
    CGFloat maxW = cellW - iconWH - 3* HWStatusCellBorderW - KViewWidth(10);
    CGSize contentSize = [_commentModel.content sizeWithFont:HWStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    if (self.isReply) {
//        maxW =maxW - 10;
        NSString *totalString = [_commentModel.name stringByAppendingFormat:@"%@ 回复 %@:%@",_commentModel.name,_commentModel.pname,_commentModel.content];
        contentSize = [totalString sizeWithFont:HWStatusCellContentFont maxW:maxW];
        self.contentLabelF = (CGRect){{KViewWidth(75), HWStatusCellBorderW}, contentSize.width,contentSize.height + KViewHeight(8)};
    }
    
    /** 气泡 */
//    CGFloat timeLabelX = nameX - 20;
//    CGFloat timeLabelY =CGRectGetMaxY(self.nameLabelF) + HWStatusCellBorderW;
//    //    CGFloat mas = cellW - iconWH - 3* HWStatusCellBorderW;
////    CGSize timeLabelSize = [_commentModel.created_time sizeWithFont:HWStatusCellContentFont maxW:maxW];
//    self.timelabelF = (CGRect){{timeLabelX, timeLabelY},  {paopaoSize.width + 70,paopaoSize.height + 30}};
//    if (self.isReply) {
//        self.timelabelF = (CGRect){{kScreenWidth - paopaoSize.width - HWStatusCellBorderW * 2 - iconWH - 50, paopaoY}, {paopaoSize.width + 70,paopaoSize.height + 30}};
//    }
    
    /** 整体 */
    CGFloat originalX = 0;
    CGFloat originalY = HWStatusCellMargin;
    CGFloat originalW = cellW;
    CGFloat originalH = 0;
    originalH = CGRectGetMaxY(self.contentLabelF) + KViewHeight(15);
    self.originalViewF = CGRectMake(originalX, 0, originalW, originalH);
    if (self.isReply) {
        self.originalViewF = CGRectMake(KViewWidth(70), 0, kScreenWidth - KViewWidth(80), CGRectGetMaxY(self.contentLabelF) + KViewHeight(5));
    }
    
}

@end
