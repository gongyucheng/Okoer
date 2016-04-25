//
//  OBSlideCell.m
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBSlideCell.h"

@interface OBSlideCell ()
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *subtitle;
@property (nonatomic, retain) UIImageView *iconImage;
@end
@implementation OBSlideCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"slideCell";
    OBSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBSlideCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
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
//    CGFloat rowHeight = KViewHeight(90);
    CGFloat picWidth = KViewHeight(50);
    CGFloat picLeftEdge = KViewWidth(8);
    
    //商品图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(picLeftEdge, KViewHeight(15), picWidth, picWidth)];
    self.iconImage = imageView;
//    imageView.backgroundColor = HWRandomColor;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = picWidth/2;
    [self.contentView addSubview:imageView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + picLeftEdge, KViewHeight(12), KSlideWidth - picLeftEdge * 3 - picWidth, KViewHeight(30))];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"维护费为加热ieo9po奇偶分级分公司 偶发是佛色粉高";
    titleLabel.font = [UIFont systemFontOfSize:KFont(18.0)];
    [self.contentView addSubview:titleLabel];
    self.title = titleLabel;
    
    //副标题
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom + 5, titleLabel.width, KViewHeight(30))];
    //    publisherLabel.backgroundColor = HWRandomColor;
    subtitle.text = @"是佛色粉高色粉高色粉高色粉高色粉高";
    subtitle.textColor = HWColor(153, 153, 153);
    subtitle.numberOfLines = 0;
    subtitle.font = [UIFont systemFontOfSize:KFont(14.0)];
    [self.contentView addSubview:subtitle];
    self.subtitle = subtitle;
}

- (void)setImageString:(NSString *)imageString
{
    _imageString = imageString;
    self.iconImage.image = [UIImage imageNamed:_imageString];
   
}
- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
     self.title.text = _titleString;
   
}
- (void)setSubtitleString:(NSString *)subtitleString
{
    _subtitleString = subtitleString;
    self.subtitle.text = _subtitleString;
   
    
}

@end
