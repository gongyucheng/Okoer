//
//  OBChatListCell.m
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBChatListCell.h"
@interface OBChatListCell ()
@property (nonatomic, retain) UIImageView *productimage;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *subtitle;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UILabel *lastChatLabel;
@property (nonatomic, retain) UIImageView *iconImage;

@end
@implementation OBChatListCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"recommend";
    OBChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBChatListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundView = nil;
        //                cell.backgroundColor = HWRandomColor;
        
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
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self initViews];
        
    }
    return self;
}

- (void)initViews
{
    CGFloat rowHeight = KViewHeight(200);
    CGFloat picWidth = KViewHeight(90);
    CGFloat picLeftEdge = KViewWidth(15);
    
    //商品图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(picLeftEdge, KViewHeight(15), picWidth, picWidth)];
    self.productimage = imageView;
//        imageView.backgroundColor = HWRandomColor;
    [self.contentView addSubview:imageView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + picLeftEdge, KViewHeight(15), kScreenWidth - picLeftEdge * 3 - picWidth, KViewHeight(50))];
//        titleLabel.backgroundColor = HWRandomColor;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"维护费为加热ieo9po奇偶分级分公司 偶发是佛色粉高";
    titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [self.contentView addSubview:titleLabel];
    self.title = titleLabel;
    
    //副标题
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom + KViewHeight(5), titleLabel.width, KViewHeight(50))];
//        subtitle.backgroundColor = HWRandomColor;
    subtitle.text = @"是佛色粉高色粉高色粉高色粉高色粉高";
    subtitle.textColor = HWColor(153, 153, 153);
    subtitle.numberOfLines = 0;
    subtitle.font = [UIFont systemFontOfSize:KFont(14.0)];
    [self.contentView addSubview:subtitle];
    self.subtitle = subtitle;
    //线条
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView.bottom + KViewHeight(30), kScreenWidth, 1)];
    line.image = [UIImage imageNamed:@"u19_line"];
    line.backgroundColor = HWColor(242, 242, 242);
    [self.contentView addSubview:line];
    //聊天数
    UIImageView *chatIcon = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(20), line.bottom + KViewHeight(12), KViewWidth(30), KViewWidth(30))];
    chatIcon.image = [UIImage imageNamed:@"u96"];
//    line.image = [UIImage imageNamed:@"u19_line"];
//    chatIcon.backgroundColor = OBColor(242, 242, 242);
    [self.contentView addSubview:chatIcon];
    
    UILabel *chatLabel = [[UILabel alloc]initWithFrame:CGRectMake(chatIcon.left + KViewWidth(25) , chatIcon.top - KViewHeight(5), KViewWidth(30), KViewHeight(20))];
//        chatLabel.backgroundColor = HWRandomColor;
    chatLabel.text = @"89";
    chatLabel.font = [UIFont boldSystemFontOfSize:KFont(13.0)];
    chatLabel.textColor = HWColor(84, 167, 86);
//    chatLabel.backgroundColor = HWRandomColor;
    [self.contentView addSubview:chatLabel];
    self.countLabel = chatLabel;
    
    //头像
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(chatIcon.right + KViewWidth(40),chatIcon.top, KViewWidth(40), KViewWidth(40))];
    iconImage.layer.masksToBounds = YES;
    iconImage.centerY = chatIcon.centerY;
    iconImage.layer.cornerRadius = iconImage.width/2;
//    line.image = [UIImage imageNamed:@"u19_line"];
    iconImage.backgroundColor = HWColor(242, 242, 242);
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    
    //聊天内容
    UILabel *lastChat = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.right + KViewWidth(5), iconImage.top, KViewWidth(200), KViewHeight(40))];
//        lastChat.backgroundColor = HWRandomColor;
    lastChat.text = @"fefgegegewwwwwwwwwwwwwwwwww";
    lastChat.font = [UIFont systemFontOfSize:KFont(13.0)];
    lastChat.textColor = HWColor(153, 153, 153);
    lastChat.numberOfLines = 0;
    [self.contentView addSubview:lastChat];
    lastChat.centerY = iconImage.centerY;
    self.lastChatLabel = lastChat;
    
    
    UIImageView *bottomimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 ,(rowHeight - KViewWidth(10)), kScreenWidth,KViewWidth(10))];
    bottomimageView.backgroundColor = HWColor(242, 242, 242);
    [self.contentView addSubview:bottomimageView];
}

- (void)setListModel:(OBChatListModel *)listModel
{
    if (_listModel != listModel) {
        _listModel = listModel;
        [self.productimage sd_setImageWithURL:[NSURL URLWithString:_listModel.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
        self.title.text = _listModel.title;
        NSMutableAttributedString * attributedString1 = [NSString attributedStringWithText:self.title.text WithLineSpace:KViewHeight(3)];
        [self.title setAttributedText:attributedString1];
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.subtitle.text = _listModel.subtitle;
        NSMutableAttributedString * attributedString2 = [NSString attributedStringWithText:self.subtitle.text WithLineSpace:KViewHeight(3)];
        [self.subtitle setAttributedText:attributedString2];
        self.subtitle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        if (_listModel.chat_count == 0) {
            self.countLabel.hidden = YES;
            
        }else if (_listModel.chat_count <= 99) {
            self.countLabel.hidden = NO;
            self.countLabel.text =[NSString stringWithFormat:@"%ld",(long)_listModel.chat_count];
        }else {
            self.countLabel.hidden = NO;
            self.countLabel.text = @"99+";
        }

//        if (_listModel.chat_count > 99) {
//            self.countLabel.text = @"99+";
//        } else
//            self.countLabel.text =[NSString stringWithFormat:@"%ld",_listModel.chat_count];
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:_listModel.last_user_img_uri] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
        self.lastChatLabel.text = _listModel.last_message;
        if (_listModel.last_message.length == 0) {
           self.lastChatLabel.text =[NSString stringWithFormat:@"欢迎来到恪吧[%@],和志同道合的恪星人一起畅所欲言吧",_listModel.title];
        }
        
    }
}
- (void)setMessageModel:(OBChatMessageModel *)messageModel
{
    if (_messageModel != messageModel) {
        _messageModel = messageModel;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:_messageModel.user.icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
        self.lastChatLabel.text = _messageModel.msg.content;
    }
}
@end
