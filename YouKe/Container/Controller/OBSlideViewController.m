//
//  OBSlideViewController.m
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBSlideViewController.h"
#import "OBLoginViewController.h"
#import "OBPersonalViewController.h"
#import "OBSlideCell.h"
#import "OBOKOerLoginViewController.h"
#import "OBAccountTool.h"
#import "OBSlideCell.h"

@interface OBSlideViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) NSArray *listTitleArray;
@property (nonatomic, retain) NSArray *listSubTitleArray;
@property (nonatomic, retain) NSArray *listImageArray;
@property (nonatomic, retain) UILabel *userName;
@property (nonatomic, retain) UIImageView *userImage;
@end

@implementation OBSlideViewController
- (void)dealloc
{
    [OBNotificationCenter removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = HWRandomColor;
    [OBNotificationCenter addObserver:self selector:@selector(statusChanged:) name:@"LogoutNotifiCation" object:nil];
    [OBNotificationCenter addObserver:self selector:@selector(statusChanged:) name:@"LoginNotifiCation" object:nil];
     [self initViews];

    self.listTitleArray = @[@"资讯/报告",@"优恪评级",@"恪吧",@"搜索",@"关于优恪"];
    self.listImageArray = @[@"icon_0019_article48",@"icon_0018_A48",@"icon_0017_room48",@"app_0004_search48",@"icon_0016_about48"];
    self.listSubTitleArray = @[@"引领优质生活/权威检测报告",@"最直观的品牌评级",@"加入恪吧，分享消费真相",@"搜索商品、资讯、测评报告",@"更优的选择"];
}

- (void)initViews
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSlideWidth, self.view.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.sectionHeaderHeight = KViewHeight(180);
    tableView.tableHeaderView.backgroundColor = HWColor(48, 48, 60);
    tableView.backgroundColor = HWColor(56, 56, 71);
    [self.view addSubview:tableView];
}

#pragma mark - tableDataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listTitleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBSlideCell *cell = [OBSlideCell cellWithTableView:tableView];
    //    kwCell.kwDelegate = self;
    cell.titleString = self.listTitleArray[indexPath.row];
    cell.imageString = self.listImageArray[indexPath.row];
    cell.subtitleString = self.listSubTitleArray[indexPath.row];
    if (indexPath.row % 2 != 0) {
         cell.backgroundColor = HWColor(48, 48, 60);
    } else
         cell.backgroundColor = HWColor(56, 56, 71);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KViewHeight(90);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSlideWidth, KViewHeight(150))];
    imageView.backgroundColor = HWColor(48, 48, 60);
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTaped:)];
    [imageView addGestureRecognizer:singleTap];
    
    //头像
     UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.centerX - KViewWidth(40), imageView.centerY - KViewHeight(30), KViewWidth(80), KViewWidth(80))];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = userImage.width/2;
    userImage.backgroundColor = HWRandomColor;
    self.userImage = userImage;
    if ([OBAccountTool account].icon.length > 0) {
        [userImage sd_setImageWithURL:[NSURL URLWithString:[OBAccountTool account].icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
    } else
        userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
    
    //用户名
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(userImage.x - KViewWidth(20), userImage.bottom + KViewHeight(10), KViewWidth(150), KViewHeight(30))];
    userNameLabel.centerX = userImage.centerX;
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont systemFontOfSize:KFont(18.0)];
    userNameLabel.text = @"立即登录";
//    userNameLabel.backgroundColor = HWRandomColor;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    if ([OBAccountTool account]) {
        userNameLabel.text = [OBAccountTool account].name;
    }
    self.userName = userNameLabel;
    [imageView addSubview:userNameLabel];
    [imageView addSubview:userImage];
    return imageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.block(indexPath.row + 100);
}

- (void)headerViewTaped:(UIGestureRecognizer *)reg
{
    //已登录加载个人中心页 未登录加载登录页
    if ([OBManager sessionManager].status == OBSessionStatusLogin) {
        //加载个人中心页
        OBPersonalViewController *personVC = [[OBPersonalViewController alloc]init];
        [self.view.containerViewController presentViewController:personVC animated:YES completion:nil];
    } else {
        //加载登录页
        OBLoginViewController *loginVC = [[OBLoginViewController alloc]init];
        [self.view.containerViewController presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)statusChanged:(NSNotification *)noti
{
    if ([noti.name isEqualToString:@"LogoutNotifiCation"]) {
         self.userName.text = @"立即登录";
        self.userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
    } else if ([noti.name isEqualToString:@"LoginNotifiCation"]) {
        if ([OBAccountTool account]) {
            self.userName.text = [OBAccountTool account].name;
            if ([OBAccountTool account].icon.length > 0) {
              [self.userImage sd_setImageWithURL:[NSURL URLWithString:[OBAccountTool account].icon] placeholderImage:[UIImage imageNamed:@"icon_0013_head80"]];
            } else
                self.userImage.image = [UIImage imageNamed:@"icon_0013_head80"];
            
        }
        
    }
   
}
@end
