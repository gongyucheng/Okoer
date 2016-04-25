//
//  OBChatMessageFrame.m
//  YouKe
//
//  Created by obally on 15/8/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBChatMessageFrame.h"
#import "NSString+Extension.h"
#import "OBChatUserModel.h"
#import "OBChatMsgModel.h"



@implementation OBChatMessageFrame
- (void)setChatModel:(OBChatMessageModel *)chatModel
{
    _chatModel = chatModel;
    OBChatUserModel *user = chatModel.user;
     OBChatMsgModel *msg = chatModel.msg;
    // cell的宽度
    CGFloat cellW = kScreenWidth;
    /** 头像 */
    CGFloat iconWH = KViewWidth(50);
    CGFloat iconX = HWStatusCellBorderW;
    CGFloat iconY = HWStatusCellBorderW;
     self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    if (self.isCurrentUser) {
       self.iconViewF = CGRectMake(kScreenWidth - iconX - iconWH, iconY, iconWH, iconWH);
    }
   
    /** 时间 */
//    CGFloat timeX = 0;
    CGFloat timeY = 0;
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSInteger time = msg.revision/1000;
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    CGSize timeSize = [currentDateStr sizeWithFont:HWStatusCellNameFont];
    if (self.showTimeLabel || self.showTimeLabelWithYear) {
         self.timeLabelF = (CGRect){{(kScreenWidth - timeSize.width)/2, timeY}, timeSize};
    } else
        self.timeLabelF = CGRectZero;
   
  
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HWStatusCellBorderW;
    CGFloat nameY = iconY + KViewWidth(5);
    CGSize nameSize = [user.name sizeWithFont:HWStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    if (self.isCurrentUser) {
        self.nameLabelF = (CGRect){{kScreenWidth - iconWH - HWStatusCellBorderW * 2 - nameSize.width, nameY}, nameSize};
    }
   
    /** 正文 */
    CGFloat contentX = nameX + KViewWidth(20);
    CGFloat contentY =CGRectGetMaxY(self.nameLabelF) + HWStatusCellBorderW + KViewWidth(15);
    CGFloat maxW = cellW - iconWH - 3* HWStatusCellBorderW - KViewWidth(20);
    CGSize contentSize = [msg.content sizeWithFont:HWStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    if (self.isCurrentUser) {
        self.contentLabelF = (CGRect){{kScreenWidth - contentSize.width - HWStatusCellBorderW * 2 - iconWH - KViewWidth(20), contentY}, contentSize};
    }
    
    /** 气泡 */
    CGFloat paopaoX = nameX - KViewWidth(20);
    CGFloat paopaoY =CGRectGetMaxY(self.nameLabelF) + HWStatusCellBorderW;
//    CGFloat mas = cellW - iconWH - 3* HWStatusCellBorderW;
    CGSize paopaoSize = [msg.content sizeWithFont:HWStatusCellContentFont maxW:maxW];
    self.paopaoViewlF = (CGRect){{paopaoX, paopaoY},  {paopaoSize.width + KViewWidth(80),paopaoSize.height + KViewWidth(30)}};
    if (self.isCurrentUser) {
        self.paopaoViewlF = (CGRect){{kScreenWidth - paopaoSize.width - HWStatusCellBorderW * 2 - iconWH - KViewWidth(50), paopaoY}, {paopaoSize.width + KViewWidth(80),paopaoSize.height + KViewHeight(30)}};
    }
    
    /** 整体 */
    CGFloat originalX = 0;
    CGFloat originalY = HWStatusCellMargin;
    CGFloat originalW = cellW;
    CGFloat originalH = 0;
    originalH = CGRectGetMaxY(self.paopaoViewlF) + HWStatusCellBorderW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
}
@end
