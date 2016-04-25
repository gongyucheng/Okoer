//
//  OBProductListViewController.m
//  YouKe
//
//  Created by obally on 16/1/7.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBProductListViewController.h"
#import "OBSingleColorView.h"
#import "NSString+Hash.h"
#import "OBMyProductListTableView.h"
#import "OBGradeModel.h"
#import "OBAlertView.h"
@interface OBProductListViewController ()<BaseTableViewDelegate,OBMyProductListTableViewDelegate,OBAlertViewDelegate>
{
    MBProgressHUD *_hud;
    NSInteger page;
}
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) OBMyProductListTableView *productTable;
@property (nonatomic, retain) NSMutableArray *dataLists;
@property (nonatomic, retain) OBGradeModel *removeModel;
@property (nonatomic, retain) UIView *noListView;
@end

@implementation OBProductListViewController
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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(260))/2, KViewHeight(15), KViewWidth(260), KViewHeight(40))];
    titleLabel.textColor = HWColor(31, 167, 86);
    titleLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.listName;
    [visualEffect addSubview:titleLabel];
    
    //新建按钮
    UIButton *newButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(50), KViewHeight(25), KViewWidth(30), KViewWidth(24))];
    [newButton setTitle:@"新建" forState:UIControlStateNormal];
    [newButton setTitleColor:HWColor(157, 157, 157) forState:UIControlStateNormal];
    newButton.titleLabel.font = [UIFont systemFontOfSize:KFont(13.0)];
//    [newButton addTarget:self action:@selector(newButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [visualEffect addSubview:newButton];
    
    OBMyProductListTableView *listTableView = [[OBMyProductListTableView alloc]initWithFrame:CGRectMake(0, refreshHeaderView.bottom, kScreenWidth, kScreenHeight - refreshHeaderView.height) style:UITableViewStylePlain];
    self.productTable = listTableView;
    listTableView.refreshDelegate = self;
    listTableView.productTableDelegate = self;
    listTableView.refreshFooterButton.hidden = NO;
//    listTableView.backgroundColor = HWColor(242, 242, 242);
    [self.view addSubview:listTableView];
//    _hud = [MBProgressHUD showHUDAddedTo:listTableView animated:YES];
}
- (void)initNoListView
{
    //    self.listTable.refreshFooterButton.hidden = YES;
    self.productTable.refreshFooterButton.hidden = YES;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,self.effectView.bottom, kScreenWidth, kScreenHeight - self.effectView.bottom)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    self.noListView = view;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(250))/2, KViewHeight(120), KViewWidth(250), KViewHeight(40))];
    titleLabel.textColor = HWColor(157, 157, 157);
    titleLabel.font = [UIFont systemFontOfSize:KFont(22.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"当前暂无该清单商品";
    [view addSubview:titleLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, KViewHeight(40))];
    titleLabel1.textColor = HWColor(157, 157, 157);
    titleLabel1.font = [UIFont systemFontOfSize:KFont(16.0)];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.text = @"快去优品频道添加吧";
    [view addSubview:titleLabel1];
//    titleLabel1.centerY = titleLabel.centerY;
//    //创建按钮
//    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(10),KViewHeight(280), kScreenWidth - KViewWidth(10) * 2, KViewHeight(40))];
//    [saveButton setTitle:@"" forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
//    [saveButton setBackgroundColor:HWColor(30, 167, 86)];
//    saveButton.layer.masksToBounds = YES;
//    saveButton.layer.cornerRadius = 6;
//    [saveButton addTarget:self action:@selector(createButton:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:saveButton];
}

- (void)loadData
{
    if ([OBAccountTool account]) {
        _hud = [MBProgressHUD showHUDAddedTo:self.productTable animated:YES];
        self.productTable.scrollEnabled = NO;
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
        NSNumber *pageCount = [NSNumber numberWithInteger:page];
        [params setObject:pageCount forKey:@"page"];
        [params setObject:@6 forKey:@"page_rows"];
        NSNumber *tagValue = [NSNumber numberWithInteger:self.lid];
        [params setObject:tagValue forKey:@"lid"];
        [OBDataService requestWithURL:OBGetProductListURL(uid, timeString, sign) params:params httpMethod:@"GET" completionblock:^(id result) {
            [_hud hide:YES];
            self.productTable.scrollEnabled = YES;
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
            self.productTable.scrollEnabled = YES;
            [_hud hide:YES];
            [MBProgressHUD showAlert:error];
        }];
        
    }
    
}
- (void)removeProductWithModel:(OBGradeModel *)gradeModel
{
    if ([OBAccountTool account]) {
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
        NSArray *pids = [NSArray arrayWithObject:[NSNumber numberWithInteger:gradeModel.pid]];
        NSString *pidsString = [pids componentsJoinedByString:@","];
        NSNumber *tagValue = [NSNumber numberWithInteger:self.lid];
        [params setObject:pidsString forKey:@"pids"];
        [params setObject:tagValue forKey:@"lid"];
        [OBDataService requestWithURL:OBRemoveListProductURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
            
            NSNumber *code = result[@"ret_code"];
            NSString *message = result[@"err_msg"];
            if ([code integerValue] == 0) {
                [MBProgressHUD showAlert:@"移除成功"];
                if (self.complitionBlock) {
                    self.complitionBlock();
                }
                [self.dataLists removeObject:gradeModel];
                self.productTable.dataList = self.dataLists;
                [self.productTable reloadData];
                if (self.dataLists.count == 0) {
                    self.productTable.refreshFooter = NO;
                    [self initNoListView];
                }
                
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
            [MBProgressHUD showAlert:error];
        }];
        
    }

}
- (void)praseDataWithResult:(id)result
{
    NSArray *dataArrays = result[@"data"];
    
    if (dataArrays.count > 0) {
        NSArray *listModels = [OBGradeModel objectArrayWithKeyValuesArray:dataArrays];
        [self.dataLists addObjectsFromArray:listModels];
        self.productTable.dataList = self.dataLists;
        [self.productTable reloadData];
        if (listModels.count >= 6) {
            self.productTable.refreshFooter = YES;
        } else {
            self.productTable.refreshFooter = NO;
        }
    } else
        self.productTable.refreshFooter = NO;
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
    [self loadData];
}

- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - OBMyProductListTableViewDelegate
- (void)myProductListTableViewDidSelectedRemoveButtonWithGradeModel:(OBGradeModel *)gradeModel
{
    OBAlertView *alertView = [[OBAlertView alloc]initAlertViewWithTitle:@"确认将该商品移除清单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"移出"];
    [self.view addSubview:alertView];
    self.removeModel = gradeModel;
//    [alertView show];
    
}
#pragma mark - OBAlertViewDelegate
- (void)alertView:(OBAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //取消
    } else if (buttonIndex == 1) {
        //移除
        [self removeProductWithModel:self.removeModel];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
