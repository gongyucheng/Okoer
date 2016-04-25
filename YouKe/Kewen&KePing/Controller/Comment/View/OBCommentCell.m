
//
//  OBCommentCell.m
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBCommentCell.h"

@interface OBCommentCell ()
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 昵称 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 气泡 */
@property (nonatomic, weak) UILabel *timeLabel;

@end
@implementation OBCommentCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"obmessage";
    OBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundView = nil;
//        cell.backgroundColor = HWRandomColor;
        
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
    /** 原创整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.userInteractionEnabled = YES;
    [self.contentView addSubview:originalView];
//    originalView.backgroundColor = HWRandomColor;
    self.originalView = originalView;
    
    /** 头像 */
    UIImageView *iconView = [[UIImageView alloc] init];
//    [originalView  addSubview:iconView];
    iconView.userInteractionEnabled = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = HWStatusCellNameFont;
    nameLabel.textColor = HWColor(51, 51, 51);
    //    nameLabel.backgroundColor = HWRandomColor;
    [self.contentView  addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = HWColor(204, 204, 204);
    timeLabel.font = HWStatusCellTimeFont;
    self.timeLabel = timeLabel;
    [self.contentView  addSubview:timeLabel];
//    self.timeLabel = timeLabel;


    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = HWColor(102, 102, 102);
    contentLabel.font = HWStatusCellContentFont;
    contentLabel.numberOfLines = 0;
//    contentLabel.backgroundColor = HWRandomColor;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    
    //    iconView.backgroundColor = HWRandomColor;
    
    
}
- (void)setCommentFrame:(OBCommentFrame *)commentFrame
{
    _commentFrame = commentFrame;
    
    OBCommentModel *model = commentFrame.commentModel;
    
    /** 原创微博整体 */
    self.originalView.frame = commentFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = commentFrame.iconViewF;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.image = [UIImage imageNamed:@"icon_0013_head80"];
    if ([model.name isEqualToString:[OBAccountTool account].name]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[OBAccountTool account].icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
    } else
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.user.icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];

    /** 昵称 */
    self.nameLabel.text = model.name;
    self.nameLabel.frame = commentFrame.nameLabelF;
    
    /** 正文 */
    self.contentLabel.text = model.content;
    if (commentFrame.isReply) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@ 回复 %@:%@",model.name,model.pname,model.content];
        self.contentLabel.textColor = HWColor(153, 153, 153);
        self.originalView.backgroundColor = HWColor(240, 240, 240);
//        self.originalView.backgroundColor = HWRandomColor;
        NSMutableAttributedString *attrString =
        [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
        [attrString addAttribute:NSForegroundColorAttributeName value:HWColor(83, 194, 115)
                           range:[self.contentLabel.text rangeOfString:model.name]];
        [attrString addAttribute:NSForegroundColorAttributeName value:HWColor(83, 194, 115)
                           range:[self.contentLabel.text rangeOfString:model.pname]];
        
        self.contentLabel.attributedText = attrString;
    } else {
         self.contentLabel.textColor = HWColor(102, 102, 102);
        self.originalView.backgroundColor = [UIColor whiteColor];
        

    }
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.created_time]];
    self.timeLabel.frame = commentFrame.timelabelF;
    self.timeLabel.text = currentDateStr;
    self.contentLabel.frame = commentFrame.contentLabelF;
    

}


@end
