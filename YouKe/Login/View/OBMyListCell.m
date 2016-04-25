//
//  OBMyListCell.m
//  YouKe
//
//  Created by obally on 16/1/6.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBMyListCell.h"
#import "OBMyListModel.h"

@interface OBMyListCell ()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *buyCountLabel;
@property (nonatomic, weak) UILabel *productCountLabel;
//@property (nonatomic, weak) UILabel *nameLabel;
@end
@implementation OBMyListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"collectionCell";
    OBMyListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBMyListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    CGFloat rowHeight = KViewHeight(90);
    CGFloat leftEdge = KViewWidth(15);
    //清单名称label
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftEdge, KViewHeight(15), kScreenWidth - KViewWidth(80),KViewHeight(30))];
    nameLabel.textColor = HWColor(51, 51, 51);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = @"清单名称";
    nameLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //已购买
//    UILabel *buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftEdge, nameLabel.bottom + KViewHeight(5), KViewWidth(60), KViewHeight(25))];
//    buyLabel.textColor = OBGrayColor;
//    buyLabel.text = @"已购买:";
//    buyLabel.textAlignment = NSTextAlignmentLeft;
//    buyLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
//    [self.contentView addSubview:buyLabel];
//    //已购买
//    UILabel *buyCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(buyLabel.right, nameLabel.bottom, KViewWidth(60), KViewHeight(25))];
//    buyCountLabel.textColor = OBGrayColor;
//    buyCountLabel.textAlignment = NSTextAlignmentLeft;
//    buyCountLabel.text = @"0";
//    buyCountLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
//    self.buyCountLabel = buyCountLabel;
//    [self.contentView addSubview:buyCountLabel];
    
//    //商品
    UILabel *productLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftEdge,  nameLabel.bottom + KViewHeight(5), KViewWidth(100), KViewHeight(25))];
    //    publisherLabel.backgroundColor = HWRandomColor;
    productLabel.text = @"已添加商品:";
    productLabel.textColor = HWColor(153, 153, 153);
    productLabel.numberOfLines = 0;
    productLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [self.contentView addSubview:productLabel];
//
//    //商品数量
    UILabel *productCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(productLabel.right, productLabel.top, KViewWidth(60), KViewHeight(25))];
    productCountLabel.textColor = OBGrayColor;
    productCountLabel.textAlignment = NSTextAlignmentLeft;
    productCountLabel.text = @"0";
    productCountLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
    self.productCountLabel = productCountLabel;
    [self.contentView addSubview:productCountLabel];
    //线条
    UIImageView *grayImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, rowHeight - KViewHeight(1), kScreenWidth, KViewHeight(1))];
    grayImage.backgroundColor = HWColor(234, 234, 234);
    grayImage.userInteractionEnabled = YES;
    [self.contentView addSubview:grayImage];
    
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(60),(rowHeight - KViewHeight(40))/2, KViewWidth(40), KViewHeight(40))];
    [editButton setImage:[UIImage imageNamed:@"icon_0001_right26_9.png"] forState:UIControlStateNormal];
//    [editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editButton];
    
}
- (void)editButtonAction
{

}
- (void)setListModel:(OBMyListModel *)listModel
{
    _listModel = listModel;
    self.nameLabel.text = _listModel.name;
    self.productCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_listModel.product_count];

}
@end
