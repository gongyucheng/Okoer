//
//  OBBrandCell.m
//  YouKe
//
//  Created by obally on 15/8/15.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBBrandCell.h"
#import "OBGradeListController.h"

@interface OBBrandCell ()
@property (nonatomic, retain) OBBrandModel *model;
@end
@implementation OBBrandCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"recommend";
    OBBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OBBrandCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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

}
- (void)setBrandModels:(NSArray *)brandModels
{
    if (_brandModels != brandModels) {
        _brandModels = brandModels;
        for (int i = 0; i < _brandModels.count; i ++) {
            OBBrandModel *model = _brandModels[i];
            self.model = model;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenWidth/3, 0, kScreenWidth/3, kScreenWidth/3)];
            imageView.tag = 100 + i;
//            imageView.hidden = NO;
            [self.contentView addSubview:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
//            [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic_uri] placeholderImage:[UIImage imageNamed:@"u3"]];
        }
        
        
        for (int i = 0; i < _brandModels.count; i ++) {
            OBBrandModel *model = _brandModels[i];
            //获取单元格里面的图片视图
            UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:100 + i];
            //让视图显示
            imageView.hidden = NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
        }

        //2.和前面的for循环拼接成了一个完整的3次循环，
        //  如果前面的循环了3次。后面不再循环，
        //  如果前面的循环不满足3次，后面的循环将会把剩余的次数循环掉
        for (NSInteger i = _brandModels.count; i < 3; i++) {
            //获取单元格里面的图片视图
            UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:100 + i];
            //让视图显示
            imageView.hidden = YES;
        }
        
    }
    
}
- (void)imageTap:(UITapGestureRecognizer *)gesture
{
//    [gesture locationInView:self.contentView];
    NSInteger i = gesture.view.tag - 100;
    OBGradeListController *gradeVC = [[OBGradeListController alloc]init];
    OBBrandModel *model = self.brandModels[i];
    gradeVC.brandId = model.bid;
    gradeVC.brandtitle = model.name;
    [self.gradeViewController.navigationController pushViewController:gradeVC animated:YES];
}
@end
