//
//  OBGradeViewController.m
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBGradeViewController.h"
//#import "MBProgressHUD+FTCExtension.h"
#import "OBGradeTableView.h"
#import "OBGradeModel.h"
#import "OBGradeDataTool.h"
#import "OBSingleColorView.h"

@interface OBGradeViewController ()<BaseTableViewDelegate>
{
    MBProgressHUD *_hud;
     NSInteger page;
    CGFloat _lastSelectedtag;
}
@property (nonatomic, strong) OBGradeTableView *gradeTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *topArray;
@property (nonatomic, retain)UIView *topView;
@property (nonatomic, retain) UIVisualEffectView *effectView;


@end

@implementation OBGradeViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)topArray
{
    if (!_topArray) {
        self.topArray = [[NSMutableArray alloc] init];
    }
    return _topArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.dataArray = [NSMutableArray array];
    [self initViews];
    self.view.backgroundColor = HWRandomColor;
//   [OBGradeDataTool deleSql];
    
}
- (void)loadData
{
    self.gradeTableView.scrollEnabled = NO;
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [_hud show:YES];
    //    _hud.dimBackground = YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@1 forKey:@"page"];
    [params setObject:@10 forKey:@"page_rows"];
    [OBDataService requestWithURL:OBBrandCategroyURL params:nil httpMethod:@"GET" completionblock:^(id result) {
        self.gradeTableView.scrollEnabled = YES;
        [_hud hide:YES];
        [self praseTopDataWithResult:result];
    } failedBlock:^(id error) {
        self.gradeTableView.scrollEnabled = YES;
        NSArray *topArray = @[@{@"cid":@10,@"title":@"全部"},@{@"cid":@14,@"title":@"母婴亲子"},@{@"cid":@15,@"title":@"美容时尚"},@{@"cid":@19,@"title":@"食品饮料"},@{@"cid":@22,@"title":@"居家及其它"}];
        [self.topArray addObjectsFromArray:topArray];
        [self initTopView];
        [self loadContentDataWithTag:_lastSelectedtag];
        [MBProgressHUD showAlert:error];
    }];
}
- (void)praseTopDataWithResult:(id)result
{
    NSString *err_msg = result[@"err_msg"];
    if ([err_msg isEqualToString:@"ok"]) {
        NSArray *dataArray = result[@"data"];
        NSDictionary *total = @{@"cid":@10,@"title":@"全部"};
        self.topArray = [NSMutableArray arrayWithArray:dataArray];
        [self.topArray insertObject:total atIndex:0];
        [self initTopView];
        [self loadContentDataWithTag:_lastSelectedtag];
    }
}

- (void)initViews
{
    
    CGFloat height;
    if (ios7) {
        height = 0;
    } else
        height = 20;
    OBGradeTableView *gradetableView = [[OBGradeTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KViewHeight(60) + height) style:UITableViewStylePlain];
    gradetableView.refreshDelegate = self;
    self.gradeTableView = gradetableView;
    gradetableView.refreshFooterButton.hidden = NO;
    [self.view addSubview:gradetableView];
    

   
}
- (void)initTopView
{
    OBSingleColorView *refreshHeaderView = [[OBSingleColorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(50))];
    [self.view addSubview:refreshHeaderView];
    
    CGFloat topViewHeight =  KViewHeight(50);
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineImage.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineImage];
    //1.创建顶部Button
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, topViewHeight)];
    //    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    self.topView = topView;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView = visualEffect;
    visualEffect.frame = topView.frame;
    visualEffect.alpha = 1.0;
    [topView addSubview:visualEffect];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *cidArray = [NSMutableArray array];
    for (NSDictionary *dic in self.topArray) {
        NSString *title = dic[@"title"];
        NSString *cid = dic[@"cid"];
        [titleArray addObject:title];
        [cidArray addObject:cid];
        
    }
    CGFloat xOffset = KViewWidth(6);
    for (int i = 0; i < self.topArray.count; i ++) {
        if (titleArray.count > 0 && cidArray.count > 0) {
            NSString *title = titleArray[i];
            NSString *cid = cidArray[i];
            CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(14.0)]} context:nil];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xOffset , 0, rect.size.width + KViewWidth(8), topViewHeight)];
            [button setTitle:title forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
            [button setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            button.tag = [cid integerValue];
            
            if (i == 0) {
                [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
                button.selected = YES;
                button.titleLabel.font = [UIFont boldSystemFontOfSize:KFont(15.0)];
                _lastSelectedtag = [cid integerValue];
            }
            [button addTarget:self action:@selector(didSelected:) forControlEvents:UIControlEventTouchUpInside];
            [visualEffect addSubview:button];
            xOffset += rect.size.width + KViewWidth(11);
        }
        
    }
    CGFloat height;
    if (ios7) {
        height = 0;
    } else
        height = 20;
    OBGradeTableView *gradetableView = [[OBGradeTableView alloc]initWithFrame:CGRectMake(0, self.topView.bottom, kScreenWidth, kScreenHeight - KViewHeight(80)- KViewHeight(50) + height) style:UITableViewStylePlain];
    gradetableView.refreshDelegate = self;
    self.gradeTableView = gradetableView;
    gradetableView.refreshFooterButton.hidden = NO;
    [self.view addSubview:gradetableView];
  
    
}

- (void)didSelected:(UIButton *)button
{
    page = 0;
    [self.dataArray removeAllObjects];
    [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:KFont(15.0)];
    
    if (button.tag != _lastSelectedtag) {
        UIButton *lastButton = (UIButton *)[self.effectView viewWithTag:_lastSelectedtag];
        lastButton.selected = NO;
        [lastButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
        lastButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
        _lastSelectedtag = button.tag;
        [self loadContentDataWithTag:button.tag];
        [UIView animateWithDuration:0.35 animations:^{
            
        }completion:^(BOOL finished) {
            if (finished) {
                
                
            }
        }];
    }
    
    
    
}

- (void)loadContentDataWithTag:(NSInteger)tag
{
     _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
//    _hud.dimBackground = YES;
    NSNumber *pageCount = [NSNumber numberWithInteger:page];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:pageCount forKey:@"page"];
    [params setObject:@6 forKey:@"page_rows"];
    NSNumber *tagValue = [NSNumber numberWithInteger:tag];
    if (tag == 10) {
        
    } else
        [params setObject:tagValue forKey:@"cid"];
    [OBDataService requestWithURL:OBProductReportListURL params:params httpMethod:@"GET" completionblock:^(id result) {
        [_hud hide:YES];
        [self praseDataWithResult:result];
    } failedBlock:^(id error) {
        [_hud hide:YES afterDelay:2];
        if ([OBGradeDataTool listModels].count > 0) {
            self.gradeTableView.dataList = [OBGradeDataTool listModels];
            [self.gradeTableView reloadData];
        }
        [MBProgressHUD showAlert:error];
//        [KLToast showToast:error];
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
//             NSArray *listArrays = [OBGradeDataTool listModels];
            for (OBGradeModel *listModel in models) {
                if (![OBGradeDataTool isSameListModelWithModel:listModel]) {
                     [OBGradeDataTool addListModel:listModel];
                }
                
            }
        } else
            self.gradeTableView.refreshFooter = NO;
    }
    
    page ++;
}

- (void)pullDown:(BaseTableView *)tableView
{
    page = 0;
    if ([OBManager sessionManager].mode == OBSessionModeOnline) {
        [OBGradeDataTool deleSql];
    }
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self loadContentDataWithTag:_lastSelectedtag];
}

- (void)pullUp:(BaseTableView *)tableView
{
    [self loadContentDataWithTag:_lastSelectedtag];
}

-(void)didReceiveMemoryWarning
{
    NSLog(@"OBGradeViewController--didReceiveMemoryWarning");
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
