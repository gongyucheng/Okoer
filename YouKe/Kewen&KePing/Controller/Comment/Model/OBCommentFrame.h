//
//  OBCommentFrame.h
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBCommentModel.h"
// cell之间的间距
#define HWStatusCellMargin 15

// cell的边框宽度
#define HWStatusCellBorderW 10
// 昵称字体
#define HWStatusCellNameFont [UIFont systemFontOfSize:16]
// 时间字体
#define HWStatusCellTimeFont [UIFont systemFontOfSize:12]
// 正文字体
#define HWStatusCellContentFont [UIFont systemFontOfSize:15]
@interface OBCommentFrame : NSObject
/** 聊天消息整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 气泡 */
@property (nonatomic, assign) CGRect timelabelF;

@property (nonatomic,retain)OBCommentModel *commentModel;

@property (nonatomic,assign)BOOL isReply;
@end
