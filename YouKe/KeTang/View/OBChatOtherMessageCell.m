//
//  OBChatOtherMessageCell.m
//  YouKe
//
//  Created by obally on 15/8/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBChatOtherMessageCell.h"

@interface OBChatOtherMessageCell ()
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;

/** 昵称 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 气泡 */
@property (nonatomic, weak) UIImageView *paopaoView;

@end
@implementation OBChatOtherMessageCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"obchat";
    OBChatOtherMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBChatOtherMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        
    }
    return self;
}

- (void)initViews
{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    UIImageView *iconView = [[UIImageView alloc] init];
    [originalView addSubview:iconView];
//    iconView.backgroundColor = HWRandomColor;
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = HWStatusCellNameFont;
    nameLabel.textColor = HWColor(102, 102, 102);
//    nameLabel.backgroundColor = HWRandomColor;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    /** 气泡 */
    UIImageView *paopaoView = [[UIImageView alloc] init];
    self.paopaoView = paopaoView;
//    paopaoView.backgroundColor = HWRandomColor;
    [originalView addSubview:paopaoView];
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = HWStatusCellContentFont;
     contentLabel.textColor = HWColor(102, 102, 102);
    contentLabel.numberOfLines = 0;
//    contentLabel.backgroundColor = HWRandomColor;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = HWStatusCellTimeFont;
    timeLabel.textColor = HWColor(204, 204, 204);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
//    iconView.backgroundColor = HWRandomColor;


}

-(void)setMessageFrame:(OBChatMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    OBChatMessageModel *model = messageFrame.chatModel;
    OBChatUserModel *user = model.user;
    OBChatMsgModel *msg = model.msg;
    
    /** 原创微博整体 */
    self.originalView.frame = messageFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = messageFrame.iconViewF;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
        /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = messageFrame.nameLabelF;
    
    /** 正文 */
    self.contentLabel.text = msg.content;
    self.contentLabel.frame = messageFrame.contentLabelF;
    
    self.paopaoView.frame = messageFrame.paopaoViewlF;
    
    
    if (messageFrame.isCurrentUser) {
        UIImage *image = [UIImage imageNamed:@"bubbble_right"];
        image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        self.paopaoView.image = image;
    } else {
        UIImage *image = [UIImage imageNamed:@"bubbble_left"];
        image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        self.paopaoView.image = image;
    }
    self.timeLabel.frame = messageFrame.timeLabelF;
    if (messageFrame.showTimeLabel) {
        NSInteger time = msg.revision/1000;
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        self.timeLabel.text = currentDateStr;
        
    } else if (messageFrame.showTimeLabelWithYear) {        
        NSInteger time = msg.revision/1000;
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        self.timeLabel.text = currentDateStr;
    }
}

@end
