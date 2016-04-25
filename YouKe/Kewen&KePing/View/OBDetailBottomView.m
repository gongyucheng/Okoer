//
//  OBDetailBottomView.m
//  YouKe
//
//  Created by obally on 15/8/6.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBDetailBottomView.h"

@implementation OBDetailBottomView

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
    CGFloat widthEdge =15;
    //返回
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, KViewHeight(2), 48 , 48)];
    backButton.backgroundColor = HWRandomColor;
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    //聊天室
    UIButton *chatButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(140), KViewHeight(10), 36 , 36)];
    chatButton.backgroundColor = HWRandomColor;
    [chatButton addTarget:self action:@selector(chatButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chatButton];
    UILabel *chatLabel = [[UILabel alloc]initWithFrame:CGRectMake(chatButton.centerX, chatButton.y - 5, 40, 20)];
    chatLabel.textColor = [UIColor whiteColor];
    chatLabel.font = [UIFont systemFontOfSize:12];
    chatLabel.textAlignment = NSTextAlignmentCenter;
    if (self.countColor) {
        chatLabel.backgroundColor = self.countColor;
    }
    chatLabel.backgroundColor = HWColor(31, 167, 86);
    //赞
    UIButton *likeButton = [[UIButton alloc]initWithFrame:CGRectMake(chatButton.right + widthEdge, KViewHeight(10), 36 , 36)];
    likeButton.backgroundColor = HWRandomColor;
    [likeButton addTarget:self action:@selector(likeButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:likeButton];
    //评论
    UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(likeButton.right + widthEdge, KViewHeight(10), 36 , 36)];
    commentButton.backgroundColor = HWRandomColor;
    [commentButton addTarget:self action:@selector(commentButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentButton];
    //转发
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(commentButton.right + widthEdge, KViewHeight(10), 36 , 36)];
    shareButton.backgroundColor = HWRandomColor;
    [shareButton addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
}
//- (void)createButtonWithFrame:(CGRect *)frame 
#pragma mark - tapAction
- (void)backButton
{

}
- (void)chatButton
{
    
}
- (void)likeButton
{
    
}
- (void)commentButton
{
    
}

- (void)shareButton
{
    
}


@end
