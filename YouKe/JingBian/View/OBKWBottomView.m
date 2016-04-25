//
//  OBKWBottomView.m
//  YouKe
//
//  Created by obally on 15/7/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKWBottomView.h"
@interface OBKWBottomView ()

@property (nonatomic, retain) UILabel *chatCountlabel;
@property (nonatomic, retain) UILabel *likeCountlabel;
@property (nonatomic, retain) UILabel *commentCountlabel;


@end

@implementation OBKWBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HWRandomColor;
        [self initViews];
        self.height = KViewHeight(50);
    }
    return self;
}
- (void)initViews
{
    CGFloat widthEdge = 15;
    //时间
    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, KViewHeight(5),80 , 36)];
    timelabel.backgroundColor = HWRandomColor;
    timelabel.textAlignment = NSTextAlignmentCenter;
    timelabel.text = @"2015-09-03";
    timelabel.font = [UIFont systemFontOfSize:12];
    timelabel.textColor = HWColor(240, 240, 240);
    [self addSubview:timelabel];
    //赞
    UIButton *likeButton = [self createButtonWithFrame:CGRectMake(KViewWidth(190), KViewHeight(5), 36 , 36) WithBackgroundImage:nil WithCountLabel:self.likeCount];
    [likeButton addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
    [likeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [likeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    UILabel *likeCountlabel = [self createLabelWithFrame:CGRectMake(likeButton.centerX, likeButton.top - 4, 40, 20)];
    self.likeCountlabel = likeCountlabel;
    
    //评论
    UIButton *commentButton = [self createButtonWithFrame:CGRectMake(likeButton.right + widthEdge, KViewHeight(5), 36 , 36) WithBackgroundImage:nil WithCountLabel:self.commentCount];
    [commentButton addTarget:self action:@selector(commentButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel *commentCountlabel = [self createLabelWithFrame:CGRectMake(commentButton.centerX, commentButton.top - 4, 40, 20)];
    self.commentCountlabel = commentCountlabel;

    //转发
    UIButton *shareButton =  [self createButtonWithFrame:CGRectMake(commentButton.right + widthEdge, KViewHeight(5), 36 , 36) WithBackgroundImage:nil];
    [shareButton addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];

}

- (UIButton *)createButtonWithFrame:(CGRect)frame WithBackgroundImage:(NSString *)imageString
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
         button.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:imageString]];
    [self addSubview:button];
    return button;
}

- (UIButton *)createButtonWithFrame:(CGRect)frame WithBackgroundImage:(NSString *)imageString WithCountLabel:(NSInteger)count
{
    //转发
    UIButton *button = [self createButtonWithFrame:frame WithBackgroundImage:imageString];
    return button;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
//    label.m
    label.layer.cornerRadius = frame.size.height/2;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = HWColor(254, 172, 132);
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    return label;
}
//评论
- (void)setCommentCount:(NSInteger)commentCount
{
    if (_commentCount != commentCount) {
        _commentCount = commentCount;
        self.commentCountlabel.text =[NSString stringWithFormat:@"%ld", _commentCount];
    }
}
//赞
- (void)setLikeCount:(NSInteger)likeCount
{
    if (_likeCount!= likeCount) {
        _likeCount = likeCount;
        self.likeCountlabel.text = [NSString stringWithFormat:@"%ld", _likeCount];
//        [self setNeedsLayout];
    }
}
#pragma mark - tapAction

- (void)likeButton:(UIButton *)likeButton
{
    likeButton.selected = !likeButton.selected;
    if (self.kwbottomDelegate && [self.kwbottomDelegate respondsToSelector:@selector(didSelectedLoveButtonWithSelected:)] && likeButton.selected) {
        [self.kwbottomDelegate didSelectedLoveButtonWithSelected:YES];
    } else if (self.kwbottomDelegate && [self.kwbottomDelegate respondsToSelector:@selector(didSelectedLoveButtonWithSelected:)] && !likeButton.selected) {
        [self.kwbottomDelegate didSelectedLoveButtonWithSelected:NO];
    }
}
- (void)commentButton
{
    if ([self.kwbottomDelegate respondsToSelector:@selector(didSelectedCommentButton)]) {
        [self.kwbottomDelegate didSelectedCommentButton];
    }
}

- (void)shareButton
{
    if ([self.kwbottomDelegate respondsToSelector:@selector(didSelectedShareButton)]) {
        [self.kwbottomDelegate didSelectedShareButton];
    }
}

@end
