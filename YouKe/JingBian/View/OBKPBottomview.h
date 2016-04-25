//
//  OBBottomview.h
//  YouKe
//
//  Created by obally on 15/7/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//  评论 赞  转发按钮 集成面板

#import <UIKit/UIKit.h>
@protocol OBBottomviewDelegate <NSObject>
@optional
- (void)didSelectedChatButton;
- (void)didSelectedLoveButton;
- (void)didSelectedCommentButton;
- (void)didSelectedShareButton;
@end

@interface OBKPBottomview : UIView
@property(nonatomic,assign)id<OBBottomviewDelegate> kpbottomDelegate;
@property(nonatomic,assign)NSInteger chatCount;
@property(nonatomic,assign)NSInteger likeCount;
@property(nonatomic,assign)NSInteger commentCount;
@end
