//
//  OBKPRelatedCardView.m
//  YouKe
//
//  Created by obally on 15/8/20.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKPRelatedCardView.h"
#import "OBKPListModel.h"

@interface OBKPRelatedCardView ()
@property (nonatomic, retain) UIImageView *topImageView;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *subTitle;
@property (nonatomic, retain) UILabel *content;
@property (nonatomic, retain) UILabel *categroyLabel;
@property (nonatomic, retain) UILabel *chatCountlabel;
@property (nonatomic, retain) UILabel *commentCountlabel;
@property (nonatomic, retain) UIView *categroyView;
@property (nonatomic, retain) UIButton *commentButton;
@property (nonatomic, retain) UIButton *chatButton;
@end

@implementation OBKPRelatedCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTopViews];
        [self initBottomViews];
        UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
- (void)initTopViews
{
    //上面图片部分
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds=YES;
    //    topImageView.backgroundColor = HWRandomColor;
    [self addSubview:topImageView];
    self.topImageView = topImageView;
    
    UIImageView *maskView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    [self addSubview:maskView];
    maskView.userInteractionEnabled = YES;
    //    maskView.backgroundColor = HWRandomColor;
    maskView.image = [UIImage imageNamed:@"u16"];
    
    UIView *categroyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(40))];
    [maskView addSubview:categroyView];
    self.categroyView = categroyView;
    UILabel *greenLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0, KViewWidth(80), KViewHeight(4))];
    greenLabel.backgroundColor = HWColor(35, 144, 79);
    [categroyView addSubview:greenLabel];
    UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, greenLabel.bottom, KViewWidth(80), KViewHeight(36))];
    //    categoryLabel.backgroundColor = HWRandomColor;
    categoryLabel.text =@"报告";
    categoryLabel.textColor = HWColor(255, 255, 255);
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    categoryLabel.font = [UIFont boldSystemFontOfSize:KFont(16.0)];
    categoryLabel.numberOfLines = 0;
    [categroyView addSubview:categoryLabel];
    self.categroyLabel = categoryLabel;
    
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(260), kScreenWidth - KViewWidth(20), KViewHeight(50))];
    //    label.backgroundColor = HWRandomColor;
    label.text =@"为非无法奇偶额佛牌分分将诶";
    label.textColor = HWColor(255, 255, 255);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    label.numberOfLines = 0;
    self.title = label;
    [self addSubview:label];
    
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, label.bottom, kScreenWidth - KViewWidth(20), KViewHeight(40))];
    //    subLabel.backgroundColor = HWRandomColor;
    subLabel.text =@"为非无法奇偶额外 哦进卧房建瓯盘就付金额佛陪啊佛牌分分将诶";
    subLabel.textColor = HWColor(255, 255, 255);
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    self.subTitle = subLabel;
    //    [topImageView addSubview:subLabel];
    
    //聊天室
    UIButton *chatButton = [self createButtonWithFrame:CGRectMake(KViewWidth(10), label.bottom + KViewHeight(10), KViewWidth(24) , KViewWidth(24)) WithBackgroundImage:@"icon_0003_chatroom20"];
    //    chatButton.backgroundColor = HWRandomColor;
    [chatButton addTarget:self action:@selector(relatedchatButton) forControlEvents:UIControlEventTouchUpInside];
    self.chatButton = chatButton;
    UILabel *chatCountlabel = [self createLabelWithFrame:CGRectMake(chatButton.centerX + KViewWidth(3), chatButton.top - 4, 40, 20)];
    self.chatCountlabel = chatCountlabel;
    //评论
    UIButton *commentButton =[self createButtonWithFrame:CGRectMake(kScreenWidth - KViewWidth(80), chatButton.top, KViewWidth(24) , KViewHeight(24)) WithBackgroundImage:@"icon_0005_reply20"];
    self.commentButton = commentButton;
    [commentButton addTarget:self action:@selector(relatedcommentButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel *commentCountlabel = [self createLabelWithFrame:CGRectMake(commentButton.centerX + KViewWidth(3), commentButton.top - KViewHeight(4), KViewWidth(30), KViewHeight(15))];
    self.commentCountlabel = commentCountlabel;
    //更多
    UIButton *moreButton =[self createButtonWithFrame:CGRectMake(kScreenWidth - KViewWidth(40), chatButton.top,KViewWidth(24) , KViewHeight(24)) WithBackgroundImage:@"icon_0006_more20"];
    [moreButton addTarget:self action:@selector(relatedmoreButton) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)initBottomViews
{
    //导语部分
    UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(0, self.topImageView.bottom, kScreenWidth,KViewHeight(480) - self.topImageView.height - KViewHeight(20))];
    //    [self.contentView addSubview:view];
    //    view.backgroundColor = HWRandomColor;
    CGFloat labelEdge = KViewWidth(10);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelEdge,self.topImageView.bottom + KViewHeight(10), view.width - labelEdge * 2, view.height - KViewHeight(20))];
    titleLabel.textColor = HWColor(102, 102, 102);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    NSString *text = @"";
    titleLabel.text = text;
    //    titleLabel.backgroundColor = HWRandomColor;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [titleLabel setAttributedText:attributedString1];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.content =titleLabel;
    
    UILabel *blabel = [[UILabel alloc]initWithFrame:CGRectMake(0,KViewHeight(480) - KViewHeight(20), kScreenWidth, KViewHeight(20))];
    blabel.backgroundColor = HWColor(240, 240, 240);
//    [self addSubview:blabel];
    
}
- (UIButton *)createButtonWithFrame:(CGRect)frame WithBackgroundImage:(NSString *)imageString
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [self  addSubview:button];
    return button;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.layer.cornerRadius = frame.size.height/2;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:KFont(12.0)];
    label.textColor = [UIColor whiteColor];
    [self  addSubview:label];
    return label;
}

- (void)setListModel:(OBKPListModel *)listModel
{
    if (_listModel != listModel) {
        _listModel = listModel;
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:_listModel.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
        self.title.text = _listModel.title;
        self.subTitle.text = _listModel.subtitle;
        if (_listModel.summary.length == 0) {
            self.content.text = @"优恪，优质生活的恪守者。以忠诚恭敬、真诚严肃的态度，恪守公平、客观、科学原则，提供严谨的产品检测报告和资讯内容，让普通消费者过上“真正的优质生活”。";
        } else
            self.content.text = _listModel.summary;
        //设置内容的间距
        NSMutableAttributedString * attributedString2 =[NSString attributedStringWithText:self.content.text WithLineSpace:KViewHeight(5)];
        [self.content setAttributedText:attributedString2];
        self.content.lineBreakMode = NSLineBreakByTruncatingTail;
        
        //        self.categroyLabel.text = _listModel.category;
        if (_listModel.chat_count == 0) {
            self.chatCountlabel.hidden = YES;
            [self.chatButton setBackgroundImage:[UIImage imageNamed:@"icon_0003_chatroom20_1"] forState:UIControlStateNormal];
        }else if (_listModel.chat_count <= 99) {
            self.chatCountlabel.hidden = NO;
            self.chatCountlabel.text =[NSString stringWithFormat:@"%ld",_listModel.chat_count];
            [self.chatButton setBackgroundImage:[UIImage imageNamed:@"icon_0003_chatroom20"] forState:UIControlStateNormal];
        }else {
            self.chatCountlabel.hidden = NO;
            self.chatCountlabel.text = @"99+";
            [self.chatButton setBackgroundImage:[UIImage imageNamed:@"icon_0003_chatroom20"] forState:UIControlStateNormal];
        }
        
        
        if (_listModel.comment_count == 0) {
            self.commentCountlabel.hidden = YES;
            [self.commentButton setBackgroundImage:[UIImage imageNamed:@"icon_0005_reply20_1"] forState:UIControlStateNormal];
        }else if (_listModel.comment_count <= 99) {
            self.commentCountlabel.hidden = NO;
            self.commentCountlabel.text =[NSString stringWithFormat:@"%ld",_listModel.comment_count];
            [self.commentButton setBackgroundImage:[UIImage imageNamed:@"icon_0005_reply20"] forState:UIControlStateNormal];
        }else {
            self.commentCountlabel.hidden = NO;
            self.commentCountlabel.text = @"99+";
            [self.commentButton setBackgroundImage:[UIImage imageNamed:@"icon_0005_reply20"] forState:UIControlStateNormal];
        }

    }
}


#pragma mark - KPDelegate
- (void)tapAction
{
    if ([self.relatedCardDelegate respondsToSelector:@selector(didTapRelatedView)]) {
        [self.relatedCardDelegate didTapRelatedView];
    }
}
- (void)relatedcommentButton
{
    if ([self.relatedCardDelegate respondsToSelector:@selector(didSelectedKPRelatedCommentButtonWithListModel:)]) {
        [self.relatedCardDelegate didSelectedKPRelatedCommentButtonWithListModel:_listModel];
    }
}

- (void)relatedchatButton
{
    if ([self.relatedCardDelegate respondsToSelector:@selector(didSelectedKPRelatedChatButtonWithListModel:)]) {
        [self.relatedCardDelegate didSelectedKPRelatedChatButtonWithListModel:_listModel];
    }
}

- (void)relatedmoreButton
{
    if ([self.relatedCardDelegate respondsToSelector:@selector(didSelectedKPRelatedMoreButtonWithListModel:)]) {
        [self.relatedCardDelegate didSelectedKPRelatedMoreButtonWithListModel:_listModel];
    }
    
}
@end
