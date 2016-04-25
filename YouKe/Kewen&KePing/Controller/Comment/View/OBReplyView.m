//
//  OBReplyView.m
//  YouKe
//
//  Created by obally on 15/8/27.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBReplyView.h"

@implementation OBReplyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}
-(void)initViews
{
//    self.frame = CGRectMake(0, 0, 120, 50);
    UIButton *jBbutton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(5),KViewHeight(5),KViewWidth(40), KViewHeight(40))];
    jBbutton.layer.cornerRadius = jBbutton.width/2;
    [jBbutton addTarget:self action:@selector(didSelectedJBButton:) forControlEvents:UIControlEventTouchUpInside];
    [jBbutton setTitle:@"举报" forState: UIControlStateNormal];
    jBbutton.titleLabel.textColor = [UIColor whiteColor];
    jBbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    jBbutton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    jBbutton.backgroundColor = HWColor(51, 51, 51);
    [self addSubview:jBbutton];
    
    UIButton *replyButton = [[UIButton alloc]initWithFrame:CGRectMake(jBbutton.right + KViewWidth(20) ,KViewHeight(5),KViewWidth(40), KViewHeight(40))];
    replyButton.layer.cornerRadius = replyButton.width/2;
    [replyButton addTarget:self action:@selector(didSelectedReplyButton:) forControlEvents:UIControlEventTouchUpInside];
    [replyButton setTitle:@"回复" forState: UIControlStateNormal];
    replyButton.titleLabel.textColor = [UIColor whiteColor];
    replyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    replyButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    replyButton.backgroundColor = HWColor(83,194, 115);
    [self addSubview:replyButton];
}

- (void)didSelectedJBButton:(UIButton *)button
{
    if (self.replyDelegate && [self.replyDelegate respondsToSelector:@selector(didSelectedJuBaoWithCommentModel:)]) {
        [self.replyDelegate didSelectedJuBaoWithCommentModel:self.commentModel];
    }
}

- (void)didSelectedReplyButton:(UIButton *)button
{
    if (self.replyDelegate && [self.replyDelegate respondsToSelector:@selector(didSelectedReplyWithCommentModel:)]) {
        [self.replyDelegate didSelectedReplyWithCommentModel:self.commentModel];
    }

}
@end
