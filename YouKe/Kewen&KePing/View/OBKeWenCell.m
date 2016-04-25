//
//  OBKeWenCell.m
//  YouKe
//
//  Created by obally on 15/7/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKeWenCell.h"
#import "OBKWBottomView.h"
#import "OBOKOerLoginViewController.h"
#import "NSString+Hash.h"
#import "NSString+Extension.h"

@interface OBKeWenCell ()<OBKWBottomviewDelegate>
@property (nonatomic, retain) UIImageView *topImageView;
@property (nonatomic, retain) UIView *categroyView;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *subTitle;
@property (nonatomic, retain) UILabel *content;
@property (nonatomic, retain) UILabel *categroyLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) OBKWBottomView *bottomView;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) UILabel *commentCountlabel;
@end
@implementation OBKeWenCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"kwCell";
    OBKeWenCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBKeWenCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
    //上面图片部分
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(240))];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds=YES;
    [self.contentView addSubview:topImageView];
    UIImageView *maskView = [[UIImageView alloc]initWithFrame:topImageView.frame];
    [self.contentView addSubview:maskView];
    maskView.userInteractionEnabled = YES;
    //    maskView.backgroundColor = HWRandomColor;
    maskView.image = [UIImage imageNamed:@"u16"];
    UIView *categroyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(40))];
    [maskView addSubview:categroyView];
    self.categroyView = categroyView;
    UILabel *greenLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0, KViewWidth(100), KViewHeight(4))];
    greenLabel.backgroundColor = HWColor(254, 172, 132);
    [categroyView addSubview:greenLabel];
    UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, greenLabel.bottom, KViewWidth(100), KViewHeight(36))];
    categoryLabel.text =@"资讯";
    categoryLabel.textColor = [UIColor whiteColor];
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    categoryLabel.font = [UIFont boldSystemFontOfSize:KFont(16.0)];
    categoryLabel.numberOfLines = 0;
    [categroyView addSubview:categoryLabel];
    self.categroyLabel = categoryLabel;
    //副标题
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(220) - KViewHeight(40), kScreenWidth - 20, KViewHeight(30))];
    subLabel.backgroundColor = HWRandomColor;
    subLabel.text =@"为非无法奇偶额外 哦进卧房建瓯盘就付金额佛陪啊佛牌分分将诶";
    subLabel.textColor = HWColor(255, 255, 255);
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    self.subTitle = subLabel;
    self.topImageView = topImageView;
    
}

- (void)initBottomViews
{
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewHeight(10), self.topImageView.bottom + KViewHeight(10), kScreenWidth - KViewWidth(20), KViewHeight(55))];
    label.text =@"为非无法奇偶额佛牌分分将诶非无法奇偶额佛牌分分将非无法奇偶额佛牌分分将非无法奇偶额佛牌分分将";
    label.textColor = HWColor(102, 102, 102);
    label.textAlignment = NSTextAlignmentJustified;
    label.font = [UIFont boldSystemFontOfSize:KFont(16.0)];
    label.numberOfLines = 0;
    self.title = label;
//    label.backgroundColor = HWRandomColor;
    [self.contentView addSubview:label];
    //导语部分   
    CGFloat labelEdge = KViewWidth(6);
//    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10),KViewHeight(240) + KViewHeight(40) + KViewHeight(15) + labelEdge, kScreenWidth - KViewWidth(10) * 2, KViewHeight(480) - KViewHeight(240) - KViewHeight(60) - KViewHeight(50) - KViewHeight(6) - KViewHeight(20))];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10),label.bottom + labelEdge, kScreenWidth - KViewWidth(10) * 2, KViewHeight(480) - KViewHeight(240) - KViewHeight(65) - KViewHeight(50) - KViewHeight(6) - KViewHeight(20))];
//    contentLabel.backgroundColor = HWRandomColor;
    contentLabel.textColor = HWColor(102, 102, 102);
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    NSString *text = @"";
    contentLabel.text = text;
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.content = contentLabel;

    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KViewHeight(480) - KViewHeight(50) - KViewHeight(20), kScreenWidth, KViewHeight(50))];
    bottomLabel.backgroundColor = HWColor(252, 252, 252);
    [self.contentView addSubview:bottomLabel];
    //时间
    UIImageView *timeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(10), bottomLabel.top + KViewHeight(12),  KViewWidth(20), KViewWidth(20))];
    timeIcon.centerY = bottomLabel.centerY;
//    timeIcon.backgroundColor = HWRandomColor;
    timeIcon.image = [UIImage imageNamed:@"icon_0003_time20_9"];
    [self.contentView addSubview:timeIcon];
    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(timeIcon.right, bottomLabel.top + KViewHeight(5),KViewWidth(80) , KViewHeight(36))];
    timelabel.centerY = bottomLabel.centerY;
//    timelabel.backgroundColor = HWRandomColor;
    self.timeLabel = timelabel;
    timelabel.textAlignment = NSTextAlignmentCenter;
    timelabel.text = @"2015-09-03";
    timelabel.font = [UIFont systemFontOfSize:KFont(12.0)];
    timelabel.textColor = HWColor(169, 169, 169);
    [self.contentView addSubview:timelabel];
   
    //评论
    UIButton *commentButton =[self createButtonWithFrame:CGRectMake(kScreenWidth - KViewWidth(80), timelabel.top + KViewHeight(9) , KViewWidth(24) , KViewHeight(24)) WithBackgroundImage:@"icon_0001_reply20_9"];
    commentButton.centerY = bottomLabel.centerY;
//    commentButton.backgroundColor = HWRandomColor;
    [commentButton addTarget:self action:@selector(commentButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel *commentCountlabel = [self createLabelWithFrame:CGRectMake(commentButton.centerX, commentButton.top - KViewHeight(8), KViewWidth(30), KViewHeight(17))];
    self.commentCountlabel = commentCountlabel;
    //更多
    UIButton *moreButton =[self createButtonWithFrame:CGRectMake(kScreenWidth - KViewWidth(40), commentButton.top,KViewWidth(24) , KViewHeight(24)) WithBackgroundImage:@"icon_0005_more20_9"];
    moreButton.centerY = bottomLabel.centerY;
//    moreButton.backgroundColor = HWRandomColor;
    [moreButton addTarget:self action:@selector(moreButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *blabel = [[UILabel alloc]initWithFrame:CGRectMake(0, bottomLabel.bottom, kScreenWidth, KViewHeight(20))];
    blabel.backgroundColor = HWColor(240, 240, 240);
    [self.contentView addSubview:blabel];
    
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
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = HWColor(253, 171, 132);
    label.font = [UIFont systemFontOfSize:KFont(12.0)];
    label.textColor = [UIColor whiteColor];
    [self.contentView addSubview:label];
    return label;
}

- (void)setListModel:(OBKWListModel *)listModel
{
    if (_listModel != listModel) {
        _listModel = listModel;
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:_listModel.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
        self.title.text = _listModel.title;
        NSMutableAttributedString * attributedString1 = [NSString attributedStringWithText:self.title.text WithLineSpace:KViewHeight(2)];
        [self.title setAttributedText:attributedString1];
        CGSize size = [self.title.text sizeWithFont:[UIFont boldSystemFontOfSize:KFont(16.0)] maxW:kScreenWidth - KViewWidth(20)];
        self.title.height = size.height + KViewHeight(15);
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.subTitle.text = _listModel.subtitle;
        if (_listModel.summary.length == 0) {
            self.content.text = @"优恪，优质生活的恪守者。以忠诚恭敬、真诚严肃的态度，恪守公平、客观、科学原则，提供严谨的产品检测报告和资讯内容，让普通消费者过上“真正的优质生活”。";
        } else
            self.content.text = _listModel.summary;
        //设置内容的间距
        NSMutableAttributedString * attributedString2 =[NSString attributedStringWithText:self.content.text WithLineSpace:KViewHeight(4)];
        [self.content setAttributedText:attributedString2];
         self.content.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
        if (_listModel.comment_count == 0) {
            self.commentCountlabel.hidden = YES;
            
        }else if (_listModel.comment_count <= 99) {
            self.commentCountlabel.hidden = NO;
            self.commentCountlabel.text =[NSString stringWithFormat:@"%ld",_listModel.comment_count];
        }else {
            self.commentCountlabel.hidden = NO;
            self.commentCountlabel.text = @"99+";
        }
        CGSize commentlabelSize = [self.commentCountlabel.text sizeWithFont:[UIFont systemFontOfSize:KFont(12.0)]];
        self.commentCountlabel.width = commentlabelSize.width + KViewWidth(10);
        
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_listModel.publish_time]];
        self.timeLabel.text = currentDateStr;
    }
}

- (void)setIsRecomendCell:(BOOL)isRecomendCell
{
    _isRecomendCell = isRecomendCell;
    if (!_isRecomendCell) {
        self.categroyView.alpha = 0;
    }
}


- (void)commentButton
{
    if ([self.kwDelegate respondsToSelector:@selector(didSelectedKWCommentButtonWithListModel:)]) {
        [self.kwDelegate didSelectedKWCommentButtonWithListModel:_listModel];
    }
}

- (void)moreButton
{
    if ([self.kwDelegate respondsToSelector:@selector(didSelectedKWMoreButtonWithListModel:)]) {
        [self.kwDelegate didSelectedKWMoreButtonWithListModel:_listModel];
    }
    
}
@end
