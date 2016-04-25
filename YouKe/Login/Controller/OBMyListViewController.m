//
//  OBMyListViewController.m
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBMyListViewController.h"
#import "OBSingleColorView.h"
#import "NSString+Hash.h"
#import "OBNewListViewController.h"
#import "OBMyListTableView.h"
#import "OBMyListModel.h"
@interface OBMyListViewController ()<BaseTableViewDelegate>
{
    MBProgressHUD *_hud;
    NSInteger page;
}
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) OBMyListTableView *listTable;
@property (nonatomic, retain) NSMutableArray *dataLists;
@property (nonatomic, retain) UIView *noListView;
@end

@implementation OBMyListViewController
- (NSMutableArray *)dataLists
{
    if (!_dataLists) {
        self.dataLists = [[NSMutableArray alloc] init];
    }
    return _dataLists;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadData];
//    [self initNoListView];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
    titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的清单";
    [visualEffect addSubview:titleLabel];
    
    //新建按钮
    UIButton *newButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(50), KViewHeight(25), KViewWidth(30), KViewWidth(24))];
    [newButton setTitle:@"新建" forState:UIControlStateNormal];
    [newButton setTitleColor:HWColor(157, 157, 157) forState:UIControlStateNormal];
    newButton.titleLabel.font = [UIFont systemFontOfSize:KFont(13.0)];
    [newButton addTarget:self action:@selector(newButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:newButton];
   
    OBMyListTableView *listTableView = [[OBMyListTableView alloc]initWithFrame:CGRectMake(0, refreshHeaderView.bottom, kScreenWidth, kScreenHeight - refreshHeaderView.height) style:UITableViewStylePlain];
    self.listTable = listTableView;
    listTableView.refreshFooterButton.hidden = NO;
    listTableView.refreshDelegate = self;
//    listTableView.backgroundColor = HWColor(242, 242, 242);
    [self.view addSubview:listTableView];
//    _hud = [MBProgressHUD showHUDAddedTo:listTableView animated:YES];
}
- (void)initNoListView
{
    self.listTable.refreshFooterButton.hidden = YES;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.effectView.bottom, kScreenWidth, kScreenHeight - self.effectView.height)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    self.noListView = view;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(120), KViewWidth(200), KViewHeight(40))];
    titleLabel.textColor = HWColor(157, 157, 157);
    titleLabel.font = [UIFont systemFontOfSize:KFont(22.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"当前暂无清单";
    [view addSubview:titleLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, KViewWidth(200), KViewHeight(40))];
    titleLabel1.textColor = HWColor(157, 157, 157);
    titleLabel1.font = [UIFont systemFontOfSize:KFont(16.0)];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.text = @"快来创建一个吧";
    [view addSubview:titleLabel1];
    //创建按钮
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(10),KViewHeight(280), kScreenWidth - KViewWidth(10) * 2, KViewHeight(40))];
    [saveButton setTitle:@"创建新清单" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
    [saveButton setBackgroundColor:HWColor(30, 167, 86)];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 6;
    [saveButton addTarget:self action:@selector(newButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:saveButton];
}
- (void)loadData
{
    _hud = [MBProgressHUD showHUDAddedTo:self.listTable animated:YES];
    if ([OBAccountTool account]) {
        self.listTable.scrollEnabled = NO;
        NSString *token = nil;
        NSString *uid = nil;
        if ([OBAccountTool account]) {
            OBAccount *model = [OBAccountTool account];
            token = model.token;
            uid = model.uid;
        }
        NSDate *date = [NSDate date];
        NSTimeInterval timeInterval =[date timeIntervalSince1970] ;
        NSString *timeString = [NSString stringWithFormat:@"%d",(int)timeInterval];
        if (self.currentTimeOffset) {
            NSInteger timeoffset = [self.currentTimeOffset intValue];
            NSInteger current = timeInterval + timeoffset;
            timeString = [NSString stringWithFormat:@"%ld",current];
        }
        NSString *sign = [[NSString stringWithFormat:@"%@%@%@",uid,timeString,token]md5String];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //    NSArray *array = @[[NSNumber numberWithInteger:self.nid]];
        
        [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [params setObject:@10 forKey:@"page_rows"];
        [OBDataService requestWithURL:OBListUrl(uid, timeString, sign) params:params httpMethod:@"GET" completionblock:^(id result) {
            self.listTable.scrollEnabled = YES;
            [_hud hide:YES];
            NSNumber *code = result[@"ret_code"];
            NSString *message = result[@"err_msg"];
            if ([code integerValue] == 0) {
                [self praseDataWithResult:result];
            }else if ([code integerValue] == -18) {
                message = result[@"result"];
                [MBProgressHUD showAlert:message];
            } else if ([code integerValue] == - 9){
                NSDictionary *resultDic = result[@"result"];
                NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                self.currentTimeOffset = timestamp_offset;
                [self loadData];
            }else if ([code integerValue] == - 8) {
                //token 过期
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadData)];
            }else if ([code integerValue] == - 24) {
                //签名错误
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadData)];
            }
            
        } failedBlock:^(id error) {
            [_hud hide:YES];
            self.listTable.scrollEnabled = YES;
            [MBProgressHUD showAlert:error];
        }];
        
    }

}
- (void)praseDataWithResult:(id)result
{
    NSArray *dataArrays = result[@"data"];
    
    if (dataArrays.count > 0) {
        NSArray *listModels = [OBMyListModel objectArrayWithKeyValuesArray:dataArrays];
        [self.dataLists addObjectsFromArray:listModels];
        self.listTable.dataList = self.dataLists;
        [self.listTable reloadData];
        if (listModels.count >= 10) {
            self.listTable.refreshFooter = YES;
        } else {
            self.listTable.refreshFooter = NO;
        }
    } else {
        self.listTable.refreshFooter = NO;
    }
    if (self.dataLists.count == 0) {
        //暂无商品
        [self initNoListView];
    }

    page++;
       
}
#pragma mark - BaseTableViewDelegate
- (void)pullDown:(BaseTableView *)tableView
{
    page = 0;
    if (self.dataLists.count > 0) {
        [self.dataLists removeAllObjects];
    }
    [self loadData];
}
- (void)pullUp:(BaseTableView *)tableView
{
    if (self.listTable.refreshFooter == YES) {
        [self loadData];
    } else
        self.listTable.refreshFooter = NO;
}

#pragma mark - ButtonAction
- (void)newButtonAction
{
    OBNewListViewController *newList = [[OBNewListViewController alloc]init];
    newList.successAddBlock = ^(OBMyListModel *listModel) {
        if (self.dataLists.count == 0) {
            [self.dataLists addObject:listModel];
        } else
            [self.dataLists insertObject:listModel atIndex:0];
        self.listTable.dataList = self.dataLists;
        if (self.dataLists.count > 1) {
            [self.listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        [self.listTable reloadData];
        [self.listTable layoutIfNeeded];
        if (self.noListView) {
            [self.noListView removeFromSuperview];
            self.listTable.refreshFooterButton.hidden = NO;
        }

    };
    [self.navigationController pushViewController:newList animated:YES];
}
- (void)saveButtonAction
{
    
}
- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}
@end
