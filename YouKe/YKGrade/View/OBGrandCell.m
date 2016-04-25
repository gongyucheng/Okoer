//
//  OBGrandCell.m
//  YouKe
//
//  Created by obally on 15/8/14.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBGrandCell.h"
#import "OBRankTool.h"
#import "OBRankModel.h"
#import "OBListViewController.h"
#import "OBAddListView.h"
#import "OBLoginViewController.h"
@interface OBGrandCell ()
@property (nonatomic, retain) UIImageView *productimage;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *publisherLabel;
@property (nonatomic, retain) UILabel *gradeLabel;
@property (nonatomic, retain) UILabel *gradeLabel2;
@end

@implementation OBGrandCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"recommend";
    OBGrandCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBGrandCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundView = nil;
//        cell.backgroundColor = HWColor(242, 242, 242);
        
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
    CGFloat rowHeight = KViewHeight(140) + KViewHeight(40);
    //商品图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(16), (rowHeight - KViewHeight(90) - KViewHeight(40) - KViewHeight(10))/2, KViewWidth(90), KViewHeight(90))];
    self.productimage = imageView;
//    imageView.backgroundColor = HWRandomColor;
    [self.contentView addSubview:imageView];
    
    //商品名字
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + KViewWidth(15), KViewHeight(30), KViewWidth(164), KViewHeight(50))];
//    titleLabel.backgroundColor = HWRandomColor;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"维护费为加热ieo9po奇偶分级分公司 偶发是佛色粉高";
    titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [self.contentView addSubview:titleLabel];
    self.title = titleLabel;
    
    //商品评级
    UILabel *gradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(50) - KViewWidth(20), titleLabel.top + KViewHeight(5), KViewWidth(60), KViewHeight(40))];
    gradeLabel.textAlignment = NSTextAlignmentCenter;
    gradeLabel.text = @"A";
    gradeLabel.font = [UIFont systemFontOfSize:KFont(30.0)];
    gradeLabel.textColor = HWColor(153, 153, 153);
    [self.contentView addSubview:gradeLabel];
    self.gradeLabel = gradeLabel;
    
    UILabel *gradeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(gradeLabel.left, gradeLabel.bottom + KViewHeight(5), KViewWidth(60), KViewHeight(30))];
//    gradeLabel2.backgroundColor = HWRandomColor;
    gradeLabel2.textColor = HWColor(153, 153, 153);
     gradeLabel2.text = @"优";
    gradeLabel2.textAlignment = NSTextAlignmentCenter;
    gradeLabel2.font = [UIFont systemFontOfSize:KFont(17.0)];
    [self.contentView addSubview:gradeLabel2];
    self.gradeLabel2 = gradeLabel2;
    gradeLabel2.centerX = gradeLabel.centerX;
    
    UIImageView *grayView = [[UIImageView alloc]initWithFrame:CGRectMake(0 ,imageView.bottom + KViewHeight(10), kScreenWidth,KViewHeight(2))];
    grayView.backgroundColor = HWColor(242, 242, 242);
    [self.contentView addSubview:grayView];
    //发布方
    UILabel *publisherLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(15), grayView.bottom + KViewHeight(10),kScreenWidth -  KViewWidth(120), KViewHeight(30))];
    //    publisherLabel.backgroundColor = HWRandomColor;
    publisherLabel.text = @"是佛色粉高色粉高色粉高色粉高色粉高";
    publisherLabel.textColor = HWColor(153, 153, 153);
    publisherLabel.numberOfLines = 0;
    publisherLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [self.contentView addSubview:publisherLabel];
    self.publisherLabel = publisherLabel;
    UIImageView *grayView1 = [[UIImageView alloc]initWithFrame:CGRectMake(publisherLabel.right ,grayView.top, KViewWidth(1),rowHeight - grayView.bottom)];
    grayView1.backgroundColor = HWColor(242, 242, 242);
    [self.contentView addSubview:grayView1];
    //添加清单
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(grayView1.right, publisherLabel.top, KViewWidth(105), publisherLabel.height)];
    addButton.backgroundColor = [UIColor whiteColor];
//    [addButton setTintColor:HWColor(111, 185, 90)];
    [addButton setTitle:@"+ 加入清单" forState:UIControlStateNormal];
    [addButton setTitleColor:HWColor(111, 185, 90) forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [addButton addTarget:self action:@selector(addListAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addButton];
    
    UIImageView *bottomimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 ,(rowHeight - KViewHeight(10)), kScreenWidth,KViewHeight(10))];
    bottomimageView.backgroundColor = HWColor(242, 242, 242);
    [self.contentView addSubview:bottomimageView];
}

- (void)setListModel:(OBGradeModel *)listModel
{
    if (_listModel != listModel) {
        _listModel = listModel;
        [self.productimage sd_setImageWithURL:[NSURL URLWithString:_listModel.pic_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
        self.title.text = _listModel.name;
        if (_listModel.publisher_id == 1) {
            self.publisherLabel.text = @"检测方：OKOer";
        } else
            self.publisherLabel.text = @"检测方：ÖKO-TEST";
        OBRankModel *rankModel = [OBRankTool rankModelWithRankId:_listModel.rank_id];
        self.gradeLabel.text = rankModel.name;
        self.gradeLabel2.text = rankModel.chineseName;
        self.gradeLabel.textColor = rankModel.color;
    }
}
- (void)addListAction:(UIButton *)button
{
//    if ([self.gradeCellDelegate respondsToSelector:@selector(didSelectedGrandCellAddListButtonWithGradeModel:)]) {
//        [self.gradeCellDelegate didSelectedGrandCellAddListButtonWithGradeModel:self.listModel];
//    }
    if ([OBAccountTool account]) {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
        UIWindow *lastWindow = [UIApplication sharedApplication].keyWindow;
        OBAddListView *effview  = [[OBAddListView alloc]initWithFrame:lastWindow.frame];
        effview.pid = self.listModel.pid;
        [lastWindow addSubview:effview];
    }else
    {
        OBLoginViewController *login = [[OBLoginViewController alloc]init];
        [self.navController pushViewController:login animated:YES];
    }
    
//    OBListViewController *listView = [[OBListViewController alloc]init];
//    [self.navController pushViewController:listView animated:YES];
}
@end
