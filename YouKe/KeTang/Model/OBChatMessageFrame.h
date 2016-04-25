//
//  OBChatMessageFrame.h
//  YouKe
//
//  Created by obally on 15/8/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBChatMessageModel.h"

// cell之间的间距
#define HWStatusCellMargin KViewWidth(15)

// cell的边框宽度
#define HWStatusCellBorderW KViewWidth(10)
// 昵称字体
#define HWStatusCellNameFont [UIFont systemFontOfSize:KFont(15.0)]
// 时间字体
#define HWStatusCellTimeFont [UIFont systemFontOfSize:KFont(12.0)]

// 正文字体
#define HWStatusCellContentFont [UIFont systemFontOfSize:KFont(14.0)]

@interface OBChatMessageFrame : NSObject
@property (nonatomic, retain) OBChatMessageModel *chatModel;
/** 聊天消息整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 气泡 */
@property (nonatomic, assign) CGRect paopaoViewlF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
@property(nonatomic,assign)BOOL isCurrentUser;
@property(nonatomic,assign)BOOL showTimeLabel;
@property(nonatomic,assign)BOOL showTimeLabelWithYear;
@end
