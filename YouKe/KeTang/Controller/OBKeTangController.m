//
//  OBKeTangController.m
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKeTangController.h"
#import "OBChatTableView.h"
//#import "MBProgressHUD+FTCExtension.h"
#import "OBChatListModel.h"
#import "OBSingleColorView.h"
#import "OBChatDataTool.h"

@interface OBKeTangController ()<BaseTableViewDelegate>
{
    MBProgressHUD *_hud;
    NSInteger page;
}
@property (nonatomic, retain) OBChatTableView *chatTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UIView *topView;
@end

@implementation OBKeTangController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = HWRandomColor;
    self.dataArray = [NSMutableArray array];
    [self initViews];
    [self loadData];
//    [OBChatDataTool deleSql];
//    view.backgroundColor = HWRandomColor;
}
- (void)initViews
{
     CGFloat topViewHeight =  KViewHeight(60);
    //1.创建顶
    //背部彩虹
    OBSingleColorView *backView = [[OBSingleColorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(60))];
    [self.view addSubview:backView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, topViewHeight)];
    //    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    self.topView = topView;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
//    self.effectView = visualEffect;
    visualEffect.frame = topView.frame;
    visualEffect.alpha = 1.0;
    [topView addSubview:visualEffect];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(5), KViewHeight(20), KViewWidth(60),KViewWidth(60))];
    [button setTitle:@"恪吧" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [visualEffect addSubview:button];
    
    
    OBChatTableView *chattableView = [[OBChatTableView alloc]initWithFrame:CGRectMake(0, topViewHeight, kScreenWidth, kScreenHeight - topViewHeight) style:UITableViewStylePlain];
    chattableView.refreshDelegate = self;
    self.chatTableView = chattableView;
    chattableView.refreshFooterButton.hidden = NO;
    [self.view addSubview:chattableView];
   
}
- (void)loadData
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.dimBackground = YES;
    NSNumber *pageCount = [NSNumber numberWithInteger:page];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:pageCount forKey:@"page"];
    [params setObject:@6 forKey:@"page_rows"];
    [OBDataService requestWithURL:OBChatRoomListURL params:params httpMethod:@"GET" completionblock:^(id result) {
        [_hud hide:YES];
        [self praseDataWithResult:result];
    } failedBlock:^(id error) {
        [_hud hide:YES afterDelay:2];
        if ([OBChatDataTool listModels].count > 0) {
            self.chatTableView.dataList = [OBChatDataTool listModels];
            [self.chatTableView reloadData];
        }
//        [KLToast showToast:error];
        [MBProgressHUD showAlert:error];

    }];
    page ++;
}

- (void)praseDataWithResult:(id)result
{
    NSString *errmsg = result[@"err_msg"];
    if ([errmsg isEqualToString:@"ok"]) {
        NSArray *dataArray = result[@"data"];
        if (dataArray.count > 0) {
            NSMutableArray *models = [NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                OBChatListModel *model = [OBChatListModel objectWithKeyValues:dic];
                [models addObject:model];
            }
            [self.dataArray addObjectsFromArray:models];
            self.chatTableView.dataList = self.dataArray;
            [self.chatTableView reloadData];
            if (dataArray.count >= 6) {
                self.chatTableView.refreshFooter = YES;
            } else {
                self.chatTableView.refreshFooter = NO;
            }
            for (OBChatListModel *listModel in models) {
                if (![OBChatDataTool isSameListModelWithModel:listModel]) {
                    [OBChatDataTool addListModel:listModel];
                }
            }
        } else
            self.chatTableView.refreshFooter = NO;
        
    }
}

- (void)pullDown:(BaseTableView *)tableView
{
    page = 0;
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    
    if ([OBManager sessionManager].mode == OBSessionModeOnline) {
        [OBChatDataTool deleSql];
    }
    [self loadData];
}

- (void)pullUp:(BaseTableView *)tableView
{
    [self loadData];
}
-(void)didReceiveMemoryWarning
{
    NSLog(@"OBKeTangController--didReceiveMemoryWarning");
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
