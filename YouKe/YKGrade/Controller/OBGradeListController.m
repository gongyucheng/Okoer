//
//  OBGradeListController.m
//  YouKe
//
//  Created by obally on 15/8/21.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBGradeListController.h"
#import "OBSingleColorView.h"
//#import "MBProgressHUD+FTCExtension.h"
#import "OBGradeTableView.h"
#import "OBGradeModel.h"
#import "OBGradeDataTool.h"

@interface OBGradeListController ()<BaseTableViewDelegate>
{
    MBProgressHUD *_hud;
    NSInteger page;
}
@property (nonatomic, retain) OBGradeTableView *gradeTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@end

@implementation OBGradeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self loadData];
    [self initViews];
    
    self.view.backgroundColor = HWRandomColor;
    

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)initViews
{
    //头部----------------------
    OBSingleColorView *refreshHeaderView = [[OBSingleColorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(60))];
    [self.view addSubview:refreshHeaderView];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView = visualEffect;
    visualEffect.frame = refreshHeaderView.frame;
    visualEffect.alpha = 1.0;
    [self.view addSubview:visualEffect];
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(25), KViewWidth(24), KViewWidth(24))];
    //    backButton.backgroundColor = HWRandomColor;
    [backButton setBackgroundImage:[UIImage imageNamed:@"u215"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:backButton];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(15), KViewWidth(200), KViewHeight(40))];
    titleLabel.textColor = HWColor(31, 167, 86);
    titleLabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.brandtitle;
    [visualEffect addSubview:titleLabel];
    //优品
    UIButton *bestButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(60), KViewHeight(25), KViewWidth(50), KViewHeight(26))];
    [bestButton setTitle:@"优品" forState:UIControlStateNormal];
    [bestButton setTitleColor:HWColor(31, 167, 86) forState:UIControlStateNormal];
    [bestButton setBackgroundImage:[UIImage imageNamed:@"u150"] forState:UIControlStateNormal];
    [bestButton addTarget:self action:@selector(bestButton) forControlEvents:UIControlEventTouchUpInside];
//    [visualEffect addSubview:bestButton];
    //单元格---------------------
    OBGradeTableView *gradetableView = [[OBGradeTableView alloc]initWithFrame:CGRectMake(0,KViewHeight(60), kScreenWidth, kScreenHeight - KViewHeight(60)) style:UITableViewStylePlain];
    gradetableView.refreshDelegate = self;
    gradetableView.ispinpaiVc = YES;
    self.gradeTableView = gradetableView;
    gradetableView.refreshFooterButton.hidden = NO;
    [self.view addSubview:gradetableView];
}

- (void)loadData
{
    self.gradeTableView.scrollEnabled = NO;
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [_hud show:YES];
//    _hud.dimBackground = YES;
    NSNumber *pageCount = [NSNumber numberWithInteger:page];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:pageCount forKey:@"page"];
    [params setObject:@6 forKey:@"page_rows"];
    [params setObject:[NSNumber numberWithInteger:self.brandId] forKey:@"bid"];
    [OBDataService requestWithURL:OBProductReportListURL params:params httpMethod:@"GET" completionblock:^(id result) {
        self.gradeTableView.scrollEnabled = YES;
        [_hud hide:YES];
        [self praseDataWithResult:result];
    } failedBlock:^(id error) {
        self.gradeTableView.scrollEnabled = YES;
        [_hud hide:YES afterDelay:2];
        [MBProgressHUD showAlert:error];
    }];
    
}

- (void)praseDataWithResult:(id)result
{
    NSString *errmsg = result[@"err_msg"];
    if ([errmsg isEqualToString:@"ok"]) {
        NSArray *dataArray = result[@"data"];
        if (dataArray.count > 0) {
            NSMutableArray *models = [NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                OBGradeModel *model = [OBGradeModel objectWithKeyValues:dic];
                [models addObject:model];
            }
            [self.dataArray addObjectsFromArray:models];
            self.gradeTableView.dataList = self.dataArray;
            [self.gradeTableView reloadData];
            if (dataArray.count >= 6) {
                self.gradeTableView.refreshFooter = YES;
            } else {
                self.gradeTableView.refreshFooter = NO;
            }
 
        } else
            self.gradeTableView.refreshFooter = NO;
    }
    
    page ++;
}

- (void)pullDown:(BaseTableView *)tableView
{
    page = 0;
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self loadData];
}

- (void)pullUp:(BaseTableView *)tableView
{
    [self loadData];
}
- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)bestButton
{

}
-(void)didReceiveMemoryWarning
{
    NSLog(@"OBGradeListController--didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}
@end
