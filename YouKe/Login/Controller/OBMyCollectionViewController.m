//
//  OBMyCollectionViewController.m
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBMyCollectionViewController.h"
#import "OBSingleColorView.h"
#import "OBMyCollectionTableView.h"
//#import "MBProgressHUD+FTCExtension.h"
#import "NSString+Hash.h"
#import "OBKWListModel.h"
#import "OBKPListModel.h"
#import "OBMyCollectionModel.h"

@interface OBMyCollectionViewController ()<BaseTableViewDelegate>
{
    MBProgressHUD *_hud;
    NSInteger page;
}
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) OBMyCollectionTableView *myCollectionTableView;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) NSMutableArray *dataLists;
@property (nonatomic, retain) UIView *placeholderView;
@end

@implementation OBMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadData];
    self.dataLists = [NSMutableArray array];
//    self.view.backgroundColor = HWRandomColor;
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
    [backButton setBackgroundImage:[UIImage imageNamed:@"u215"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(15), KViewWidth(200), KViewHeight(40))];
    titleLabel.textColor = HWColor(31, 167, 86);
    titleLabel.font = [UIFont systemFontOfSize:KFont(17.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"收藏";
    [visualEffect addSubview:titleLabel];
    
    //单元格---------------------
    OBMyCollectionTableView *gradetableView = [[OBMyCollectionTableView alloc]initWithFrame:CGRectMake(0,KViewHeight(60), kScreenWidth, kScreenHeight - KViewHeight(60)) style:UITableViewStylePlain];
    gradetableView.refreshDelegate = self;
    self.myCollectionTableView = gradetableView;
    [self.view addSubview:gradetableView];

}
- (void)loadData
{
    self.myCollectionTableView.scrollEnabled = NO;
    _hud = [MBProgressHUD showHUDAddedTo:self.myCollectionTableView animated:YES];
    NSNumber *pageCount = [NSNumber numberWithInteger:page];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:pageCount forKey:@"page"];
    [params setObject:@6 forKey:@"page_rows"];
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
    
//    [params setObject:[NSNumber numberWithInteger:self.brandId] forKey:@"bid"];
    [OBDataService requestWithURL:OBCollectionListURL(uid,timeString,sign) params:params httpMethod:@"GET" completionblock:^(id result) {
        [_hud hide:YES];
        self.myCollectionTableView.scrollEnabled = YES;
        NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == - 9){
            NSDictionary *resultDic = result[@"result"];
            NSString *timestamp_offset = resultDic[@"timestamp_offset"];
            self.currentTimeOffset = timestamp_offset;
            [self loadData];
        } else if ([code integerValue] == 0) {
            [self praseDataWithResult:result];
        } else if ([code integerValue] == - 8) {
            //token 过期
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadData)];
        }else if ([code integerValue] == - 24) {
            //签名错误
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadData)];
        }else

             [MBProgressHUD showAlert:@"error"];

        
    } failedBlock:^(id error) {
        self.myCollectionTableView.scrollEnabled = YES;
        [_hud hide:YES afterDelay:2];
        [KLToast showToast:error];
    }];
    
}
- (void)praseDataWithResult:(id)result
{
    NSMutableArray *dataModels = [NSMutableArray array];
    NSNumber *code = result[@"ret_code"];
    if ([code integerValue] == 0) {
        NSArray *dataArray = result[@"data"];
        if (dataArray.count > 0) {
            self.myCollectionTableView.refreshFooterButton.hidden = NO;
            for (NSDictionary *dic in dataArray) {
                OBMyCollectionModel *collectionModel = [[OBMyCollectionModel alloc]init];
                NSString *type = [dic objectForKey:@"type"];
                collectionModel.type = type;
                NSDictionary *dataDic = [dic objectForKey:@"value"];
                OBKPListModel *kpModel = [OBKPListModel objectWithKeyValues:dataDic];
                collectionModel.kpModel = kpModel;
                [dataModels addObject:collectionModel];

            }
            if (dataModels.count >= 6) {
                self.myCollectionTableView.refreshFooter = YES;
            } else {
                self.myCollectionTableView.refreshFooter = NO;
            }
            [self.dataLists addObjectsFromArray:dataModels];
            if (self.placeholderView) {
                [self.placeholderView removeFromSuperview];
                self.placeholderView = nil;
            }
            //            [OBJBKPDataTool saveJianBianData:dataModels];
        } else if(self.dataLists.count ==0){
            UIView *view2 = [[UIView alloc]initWithFrame:self.myCollectionTableView.frame];
            [self.view addSubview:view2];
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(50), KViewWidth(200), KViewHeight(50))];
            label.text = @"暂无收藏";
            label.textAlignment = NSTextAlignmentCenter;
            self.placeholderView = view2;
            [view2 addSubview:label];
        } else if (dataArray.count == 0) {
            self.myCollectionTableView.refreshFooter = NO;
        }

    } else
        self.myCollectionTableView.refreshFooter = NO;
    page ++;
    self.myCollectionTableView.dataList = self.dataLists;
    [self.myCollectionTableView reloadData];
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

@end
