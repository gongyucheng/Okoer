//
//  OBRecommendCell.m
//  YouKe
//
//  Created by obally on 15/7/29.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKePingCell.h"
#import "OBKPBottomview.h"
#import "OBOKOerLoginViewController.h"
#import "NSString+Hash.h"

@interface OBKePingCell ()<OBBottomviewDelegate>
@property (nonatomic, retain) UIImageView *topImageView;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *subTitle;
@property (nonatomic, retain) UILabel *content;
@property (nonatomic, retain) UILabel *categroyLabel;
@property (nonatomic, retain) UILabel *chatCountlabel;
@property (nonatomic, retain) UILabel *commentCountlabel;
@property (nonatomic, retain) OBKPBottomview *bottomView;
@property (nonatomic, retain) UIView *categroyView;
@property (nonatomic, retain) UIButton *kpchatRoomButton;
@property (nonatomic, retain) UIButton *kpcommentButton;

@end
@implementation OBKePingCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"kpcell";
    OBKePingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBKePingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //创转单元格内容视图
//        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initTopViews];
        [self initBottomViews];
       
    }
    return self;
}

- (void)initTopViews
{
//    CGFloat topImageHeight = 360;
    //上面图片部分
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds=YES;
//    topImageView.backgroundColor = HWRandomColor;
    [self.contentView addSubview:topImageView];
    self.topImageView = topImageView;
    
    UIImageView *maskView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    [self.contentView addSubview:maskView];
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(250), kScreenWidth - KViewWidth(20), KViewHeight(60))];
//    label.backgroundColor = HWRandomColor;
    label.text =@"为非无法奇偶额佛牌分分将诶";
    label.textColor = HWColor(255, 255, 255);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    label.numberOfLines = 0;
    self.title = label;
    [self.contentView addSubview:label];
    
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
    self.kpchatRoomButton = chatButton;
//    chatButton.backgroundColor = HWRandomColor;
    [chatButton addTarget:self action:@selector(chatButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel *chatCountlabel = [self createLabelWithFrame:CGRectMake(chatButton.centerX + KViewWidth(4), chatButton.top - KViewHeight(4), KViewWidth(30), KViewHeight(15))];
    self.chatCountlabel = chatCountlabel;
    //评论
    UIButton *commentButton =[self createButtonWithFrame:CGRectMake(kScreenWidth - KViewWidth(80), chatButton.top, KViewWidth(24) , KViewHeight(24)) WithBackgroundImage:@"icon_0005_reply20"];
    [commentButton addTarget:self action:@selector(commentButton) forControlEvents:UIControlEventTouchUpInside];
    self.kpcommentButton = commentButton;
    UILabel *commentCountlabel = [self createLabelWithFrame:CGRectMake(commentButton.centerX+ KViewWidth(4), commentButton.top - KViewHeight(4), KViewWidth(30), KViewHeight(15))];
    self.commentCountlabel = commentCountlabel;
    //更多
    UIButton *moreButton =[self createButtonWithFrame:CGRectMake(kScreenWidth - KViewWidth(40), chatButton.top,KViewWidth(24) , KViewHeight(24)) WithBackgroundImage:@"icon_0006_more20"];
    [moreButton addTarget:self action:@selector(moreButton) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIButton *)createButtonWithFrame:(CGRect)frame WithBackgroundImage:(NSString *)imageString
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
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
    
    [self.contentView addSubview:label];
    return label;
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
    [self.contentView addSubview:titleLabel];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:KViewHeight(5)];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [titleLabel setAttributedText:attributedString1];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.content =titleLabel;
    
    UILabel *blabel = [[UILabel alloc]initWithFrame:CGRectMake(0,KViewHeight(480) - KViewHeight(20), kScreenWidth, KViewHeight(20))];
    blabel.backgroundColor = HWColor(240, 240, 240);
    [self.contentView addSubview:blabel];
//    [titleLabel sizeToFit];

}

- (void)setListModel:(OBKPListModel *)listModel
{
    if (_listModel != listModel) {
        _listModel = listModel;
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:_listModel.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
        self.title.text = _listModel.title;
        NSMutableAttributedString * attributedString =[NSString attributedStringWithText:self.title.text WithLineSpace:KViewHeight(7)];
        [self.title setAttributedText:attributedString];
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
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
            [self.kpchatRoomButton setBackgroundImage:[UIImage imageNamed:@"icon_0003_chatroom20_1"] forState:UIControlStateNormal];
        }else if (_listModel.chat_count <= 99) {
            self.chatCountlabel.hidden = NO;
            self.chatCountlabel.text =[NSString stringWithFormat:@"%ld",_listModel.chat_count];
             [self.kpchatRoomButton setBackgroundImage:[UIImage imageNamed:@"icon_0003_chatroom20"] forState:UIControlStateNormal];
        }else {
            self.chatCountlabel.hidden = NO;
             self.chatCountlabel.text = @"99+";
            [self.kpchatRoomButton setBackgroundImage:[UIImage imageNamed:@"icon_0003_chatroom20"] forState:UIControlStateNormal];
        }
        
        
        if (_listModel.comment_count == 0) {
            self.commentCountlabel.hidden = YES;
            [self.kpcommentButton setBackgroundImage:[UIImage imageNamed:@"icon_0005_reply20_1"] forState:UIControlStateNormal];
        }else if (_listModel.comment_count <= 99) {
            self.commentCountlabel.hidden = NO;
            self.commentCountlabel.text =[NSString stringWithFormat:@"%ld",_listModel.comment_count];
            [self.kpcommentButton setBackgroundImage:[UIImage imageNamed:@"icon_0005_reply20"] forState:UIControlStateNormal];
        }else {
            self.commentCountlabel.hidden = NO;
            self.commentCountlabel.text = @"99+";
            [self.kpcommentButton setBackgroundImage:[UIImage imageNamed:@"icon_0005_reply20"] forState:UIControlStateNormal];
        }
        
        
    }
}

- (void)setIsRecomendCell:(BOOL)isRecomendCell
{
    _isRecomendCell = isRecomendCell;
    if (!_isRecomendCell) {
        self.categroyView.alpha = 0;
//        self.topImageView.height = KViewHeight(320);
    }
}

#pragma mark - KPDelegate
- (void)commentButton
{
    if ([self.kpDelegate respondsToSelector:@selector(didSelectedKPCommentButtonWithListModel:)]) {
        [self.kpDelegate didSelectedKPCommentButtonWithListModel:_listModel];
    }
}

- (void)chatButton
{
    if ([self.kpDelegate respondsToSelector:@selector(didSelectedKPChatButtonWithListModel:)]) {
        [self.kpDelegate didSelectedKPChatButtonWithListModel:_listModel];
    }
}

- (void)moreButton
{
    if ([self.kpDelegate respondsToSelector:@selector(didSelectedKPMoreButtonWithListModel:)]) {
        [self.kpDelegate didSelectedKPMoreButtonWithListModel:_listModel];
    }

}


@end
