//
//  OBDetailBottomView.h
//  YouKe
//
//  Created by obally on 15/8/6.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDetailBottomView : UIView

@property (nonatomic, retain) UIColor *countColor;
@property(nonatomic,assign)BOOL showLikeButton;
@property(nonatomic,assign)BOOL showCommentButton;
@property(nonatomic,assign)BOOL showShareButton;
@property(nonatomic,assign)BOOL showChatButton;
@property(nonatomic,assign)NSInteger likeCount;
@property(nonatomic,assign)NSInteger commentCount;
@property(nonatomic,assign)NSInteger chatCount;
@end
