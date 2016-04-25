//
//  OBBottomview.m
//  YouKe
//
//  Created by obally on 15/7/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKPBottomview.h"

@interface OBKPBottomview ()

@property (nonatomic, retain) UILabel *chatCountlabel;
@property (nonatomic, retain) UILabel *likeCountlabel;
@property (nonatomic, retain) UILabel *commentCountlabel;


@end

@implementation OBKPBottomview


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HWRandomColor;
        [self initViews];
        self.height = KViewHeight(60);
    }
    return self;
}
- (void)initViews
{
    CGFloat widthEdge =20;
    //聊天室
    UIButton *chatButton = [self createButtonWithFrame:CGRectMake(10, KViewHeight(5), 36 , 36) WithBackgroundImage:nil WithCountLabel:self.likeCount];

    chatButton.backgroundColor = HWRandomColor;
    [chatButton addTarget:self action:@selector(chatButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chatButton];
    UILabel *chatCountlabel = [self createLabelWithFrame:CGRectMake(chatButton.centerX, chatButton.top - 4, 40, 20)];
    self.chatCountlabel = chatCountlabel;
    //赞
    UIButton *likeButton = [self createButtonWithFrame:CGRectMake(KViewWidth(190), KViewHeight(5), 36 , 36) WithBackgroundImage:nil WithCountLabel:self.likeCount];

    likeButton.backgroundColor = HWRandomColor;
    [likeButton addTarget:self action:@selector(likeButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:likeButton];
    UILabel *likeCountlabel = [self createLabelWithFrame:CGRectMake(likeButton.centerX, likeButton.top - 4, 40, 20)];
    self.likeCountlabel = likeCountlabel;
    //评论
    UIButton *commentButton =[self createButtonWithFrame:CGRectMake(likeButton.right + widthEdge, KViewHeight(5), 36 , 36) WithBackgroundImage:nil WithCountLabel:self.commentCount];

    commentButton.backgroundColor = HWRandomColor;
    [commentButton addTarget:self action:@selector(commentButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentButton];
    UILabel *commentCountlabel = [self createLabelWithFrame:CGRectMake(commentButton.centerX, commentButton.top - 4, 40, 20)];
    self.commentCountlabel = commentCountlabel;
    //转发
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(commentButton.right + widthEdge, KViewHeight(5), 36 , 36)];
    shareButton.backgroundColor = HWRandomColor;
    [shareButton addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
}

- (UIButton *)createButtonWithFrame:(CGRect)frame WithBackgroundImage:(NSString *)imageString
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:imageString]];
    [self addSubview:button];
    return button;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.layer.cornerRadius = frame.size.height/2;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = HWColor(254, 172, 132);
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor whiteColor];

    [self addSubview:label];
    return label;
}

- (UIButton *)createButtonWithFrame:(CGRect)frame WithBackgroundImage:(NSString *)imageString WithCountLabel:(NSInteger)count
{
    //转发
    UIButton *button = [self createButtonWithFrame:frame WithBackgroundImage:imageString];
    
    return button;
}
//评论
- (void)setCommentCount:(NSInteger)commentCount
{
    if (_commentCount != commentCount) {
        _commentCount = commentCount;
        self.commentCountlabel.text = [NSString stringWithFormat:@"%ld",_commentCount];
    }
}
//聊天
- (void)setChatCount:(NSInteger)chatCount
{
    if (_chatCount != chatCount) {
        _chatCount = chatCount;
        self.chatCountlabel.text = [NSString stringWithFormat:@"%ld",_commentCount];
    }
}
//赞
- (void)setLikeCount:(NSInteger)likeCount
{
    if (_likeCount!= likeCount) {
        _likeCount = likeCount;
        self.likeCountlabel.text = [NSString stringWithFormat:@"%ld",_likeCount];
    }
}
#pragma mark - tapAction
- (void)chatButton
{
    if ([self.kpbottomDelegate respondsToSelector:@selector(didSelectedChatButton)]) {
        [self.kpbottomDelegate didSelectedChatButton];
    }
}
- (void)likeButton
{
    if ([self.kpbottomDelegate respondsToSelector:@selector(didSelectedLoveButton)]) {
        [self.kpbottomDelegate didSelectedLoveButton];
    }
}
- (void)commentButton
{
    if ([self.kpbottomDelegate respondsToSelector:@selector(didSelectedCommentButton)]) {
        [self.kpbottomDelegate didSelectedCommentButton];
    }
}

- (void)shareButton
{
    if ([self.kpbottomDelegate respondsToSelector:@selector(didSelectedShareButton)]) {
        [self.kpbottomDelegate didSelectedShareButton];
    }
}
@end
