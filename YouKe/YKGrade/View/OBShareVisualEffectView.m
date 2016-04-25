//
//  OBShareVisualEffectView.m
//  YouKe
//
//  Created by obally on 15/8/30.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBShareVisualEffectView.h"

@implementation OBShareVisualEffectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewsWithFrame:frame];
    }
    return self;
}
-(void)initViewsWithFrame:(CGRect)rect
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    visualEffect.frame = rect;
    visualEffect.alpha = 0.9;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 40, KViewHeight(50), KViewWidth(80), KViewHeight(30))];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"分享至";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:KFont(18)];
    [visualEffect addSubview:label];
    NSArray *imageArray = @[@[@"icon_0017_sina48",@"icon_0016_wechat48",@"icon_0015_F_Circle48"],@[@"icon_0012_qq48",@"icon_0013_qzone48",@"icon_0014_mail48"]];
    NSArray *labelArray = @[@[@"微博",@"微信好友",@"微信朋友圈"],@[@"QQ好友",@"QQ空间",@"邮箱"]];
    CGFloat buttonWidth = KViewWidth(48);
    CGFloat buttonEdge = KViewWidth(50);
    CGFloat leftEdge = (kScreenWidth - buttonWidth * 3 - buttonEdge * (3 - 1))/2;
    CGFloat topEdge =KViewHeight(200);
    for (int i = 0; i < imageArray.count; i ++) {
        NSArray *images = imageArray[i];
        NSArray *labels = labelArray[i];
        for (int j = 0; j < images.count; j ++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(leftEdge +j * (buttonWidth + buttonEdge), topEdge + i * (buttonWidth + KViewWidth(80)), buttonWidth, buttonWidth)];
            //            button.layer.cornerRadius = buttonWidth/2;
            button.tag = (i * images.count) + j + 200;
            [button addTarget:self action:@selector(didSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
            //            [button setTitle:array[i] forState: UIControlStateNormal];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setBackgroundImage:[UIImage imageNamed:images[j]] forState:UIControlStateNormal];
            UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(button.left - 15, button.bottom + 2, button.width + KViewWidth(30),KViewHeight(30))];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.text = labels[j];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:KFont(13)];
            [visualEffect addSubview:button];
            [visualEffect addSubview:label];
        }
        
    }
    [self addSubview:visualEffect];
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [visualEffect addGestureRecognizer:tap];
    [self addSubview:visualEffect];
}

- (void)didSelectedButton:(UIButton *)button
{
    [self removeFromSuperview];
    if (self.shareVisualDelegate && [self.shareVisualDelegate respondsToSelector:@selector(shareVisualDidSelectedShareButtonWithSelectedShareType:)]) {
        [self.shareVisualDelegate shareVisualDidSelectedShareButtonWithSelectedShareType:(button.tag - 200)];
    }
    
}

- (void)tapAction
{
    [self removeFromSuperview];
}




@end
