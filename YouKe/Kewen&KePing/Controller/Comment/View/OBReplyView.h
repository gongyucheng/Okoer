//
//  OBReplyView.h
//  YouKe
//
//  Created by obally on 15/8/27.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBCommentModel.h"
@protocol OBReplyViewDelegate <NSObject>
@optional
- (void)didSelectedJuBaoWithCommentModel:(OBCommentModel *)commentModel;
- (void)didSelectedReplyWithCommentModel:(OBCommentModel *)commentModel;
@end
@interface OBReplyView : UIView
@property(nonatomic,assign)id<OBReplyViewDelegate> replyDelegate;
@property(nonatomic,retain)OBCommentModel *commentModel;
@end
