//
//  OBCollectionCell.m
//  YouKe
//
//  Created by obally on 15/8/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBCollectionCell.h"

@interface OBCollectionCell ()
@property (nonatomic, retain) UIImageView *productimage;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *subtitle;
@property (nonatomic, retain) UILabel *typeLabel;
@end

@implementation OBCollectionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"collectionCell";
    OBCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBCollectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundView = nil;
        //        cell.backgroundColor = HWRandomColor;
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
//    CGFloat rowHeight = KViewHeight(100);
    CGFloat picWidth = KViewHeight(100);
    CGFloat picLeftEdge = KViewWidth(8);
    
    //商品图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(picLeftEdge, KViewHeight(15), picWidth, picWidth)];
    self.productimage = imageView;
    imageView.backgroundColor = HWRandomColor;
    [self.contentView addSubview:imageView];
    //类型label
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.left, imageView.bottom - KViewHeight(25), imageView.width,KViewHeight(25))];
    typeLabel.backgroundColor = HWColor(31, 167, 86);
    typeLabel.alpha = 0.8;
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.text = @"报告";
    typeLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + picLeftEdge, KViewHeight(10), kScreenWidth - picLeftEdge * 3 - picWidth, KViewHeight(60))];
    //    titleLabel.backgroundColor = HWRandomColor;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"维护费为加热ieo9po奇偶分级分公司 偶发是佛色粉高";
    titleLabel.font = [UIFont systemFontOfSize:KFont(17.0)];
    [self.contentView addSubview:titleLabel];
    self.title = titleLabel;
    
    //副标题
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom + KViewHeight(5), titleLabel.width, KViewHeight(40))];
    //    publisherLabel.backgroundColor = HWRandomColor;
    subtitle.text = @"是佛色粉高色粉高色粉高色粉高色粉高";
    subtitle.textColor = HWColor(153, 153, 153);
    subtitle.numberOfLines = 0;
    subtitle.font = [UIFont systemFontOfSize:KFont(14.0)];
    [self.contentView addSubview:subtitle];
    self.subtitle = subtitle;
    //线条
    UIImageView *grayImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, KViewHeight(150) - KViewHeight(15), kScreenWidth, KViewHeight(15))];
//    line.image = [UIImage imageNamed:@"u19_line"];
    grayImage.backgroundColor = HWColor(234, 234, 234);
    [self.contentView addSubview:grayImage];   

}
- (void)setListModel:(OBMyCollectionModel *)listModel
{
    if (_listModel != listModel) {
        _listModel = listModel;
        if ([self.listModel.type isEqualToString:@"nr"]) {
            //恪评
            self.typeLabel.text = @"报 告";
            self.typeLabel.backgroundColor = HWColor(67, 180, 100);
        } else if ([self.listModel.type isEqualToString:@"an"]) {
            //资讯
            self.typeLabel.text = @"资 讯";
            self.typeLabel.backgroundColor = HWColor(208, 124, 88);
        }
        OBKPListModel *model = listModel.kpModel;
        self.title.text = model.title;
        self.subtitle.text = model.subtitle;
        [self.productimage sd_setImageWithURL:[NSURL URLWithString:model.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];

    }
}
@end
