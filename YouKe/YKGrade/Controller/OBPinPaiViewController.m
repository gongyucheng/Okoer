//
//  OBPinPaiViewController.m
//  YouKe
//
//  Created by obally on 15/8/15.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBPinPaiViewController.h"
#import "MBProgressHUD.h"
#import "OBBrandTableView.h"
#import "OBBrandModel.h"
#import "OBSingleColorView.h"

@interface OBPinPaiViewController ()<BaseTableViewDelegate>
{
    MBProgressHUD *_hud;
    CGFloat _lastSelectedtag;
    NSInteger page;
}
@property (nonatomic, retain)UIView *topView;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) OBBrandTableView *brandTableView;
@property (nonatomic, retain) NSMutableArray *topArray;
@property (nonatomic, retain) NSMutableArray *dataArray;
@end

@implementation OBPinPaiViewController
- (NSMutableArray *)topArray
{
    if (!_topArray) {
        self.topArray = [[NSMutableArray alloc] init];
    }
    return _topArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
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
    CGFloat xOffset = KViewWidth(10);
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
            xOffset += rect.size.width + KViewWidth(20);
        }
       
    }
    CGFloat height;
    if (ios7) {
        height = 0;
    } else
        height = 20;
    OBBrandTableView *brandTableView = [[OBBrandTableView alloc]initWithFrame:CGRectMake(0, self.topView.bottom, kScreenWidth, KViewHeight(kScreenHeight - KViewHeight(50) - KViewHeight(60)+ height)) style:UITableViewStylePlain];
    brandTableView.refreshDelegate = self;
    brandTableView.tableFooterView.hidden = NO;
    self.brandTableView = brandTableView;
    [self.view addSubview:brandTableView];

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

- (void)loadData
{
    self.brandTableView.scrollEnabled = NO;
     _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@1 forKey:@"page"];
    [params setObject:@10 forKey:@"page_rows"];
    [OBDataService requestWithURL:OBBrandCategroyURL params:nil httpMethod:@"GET" completionblock:^(id result) {
         self.brandTableView.scrollEnabled = YES;
        [_hud hide:YES];
        [self praseTopDataWithResult:result];
    } failedBlock:^(id error) {
         self.brandTableView.scrollEnabled = YES;
        [MBProgressHUD showAlert:error];
        if (_hud) {
            [_hud hide:YES];
        }
        NSArray *topArray = @[@{@"cid":@14,@"title":@"母婴亲子"},@{@"cid":@15,@"title":@"美容时尚"},@{@"cid":@19,@"title":@"食品饮料"},@{@"cid":@22,@"title":@"居家及其它"}];
        [self.topArray addObjectsFromArray:topArray];
        [self initTopView];
        [self loadContentDataWithTag:_lastSelectedtag];
    }];
}

- (void)loadContentDataWithTag:(NSInteger)tag
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
    NSNumber *tagValue = [NSNumber numberWithInteger:tag];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSNumber *pageCount = [NSNumber numberWithInteger:page];
    [params setObject:pageCount forKey:@"page"];
    [params setObject:@15 forKey:@"page_rows"];
    [params setObject:tagValue forKey:@"cid"];
    [OBDataService requestWithURL:OBBrandListURL params:params httpMethod:@"GET" completionblock:^(id result) {
        if (_hud) {
            [_hud hide:YES];
        }
        [self praseContentDataWithResult:result];
    } failedBlock:^(id error) {
        if (_hud) {
            [_hud hide:YES];
        }
        [MBProgressHUD showAlert:error];
    }];

}

- (void)praseTopDataWithResult:(id)result
{
    NSString *err_msg = result[@"err_msg"];
    if ([err_msg isEqualToString:@"ok"]) {
        NSArray *dataArray = result[@"data"];
        [self.topArray addObjectsFromArray:dataArray];
        [self initTopView];
        [self loadContentDataWithTag:_lastSelectedtag];
    }
}
- (void)praseContentDataWithResult:(id)result
{
    NSString *err_msg = result[@"err_msg"];
    if ([err_msg isEqualToString:@"ok"]) {
        NSArray *dataArray = result[@"data"];
        if (dataArray.count >= 15) {
            self.brandTableView.refreshFooter = YES;
        } else {
            self.brandTableView.refreshFooter = NO;
        }
        NSMutableArray *brandModels = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            OBBrandModel *brandModel = [OBBrandModel objectWithKeyValues:dic];
            [brandModels addObject:brandModel];
        }
        [self.dataArray addObjectsFromArray:brandModels];
        //转化为二维数组
        NSMutableArray *data = [NSMutableArray array];
        //声名一个指向数组的指针
        NSMutableArray *array2d = nil;
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            if (i % 3 == 0) {
                //创建小树组
                array2d = [NSMutableArray array];
                //把小数组添加到大数组种
                [data addObject:array2d];
            }
            //把值添加到小数组种
            [array2d addObject:self.dataArray[i]];
        }
        
        self.brandTableView.dataList = data;
        [self.brandTableView reloadData];
    }
    page ++;
}

- (void)pullDown:(BaseTableView *)tableView
{
    page = 0;
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self loadContentDataWithTag:_lastSelectedtag];
}
//- (void)pullDown:(BaseTableView *)tableView
//{
//    page = 0;
//    if ([OBManager sessionManager].mode == OBSessionModeOnline) {
//        [OBGradeDataTool deleSql];
//    }
//    [self.dataArray removeAllObjects];
//    [self loadData];
//}

- (void)pullUp:(BaseTableView *)tableView
{
    [self loadContentDataWithTag:_lastSelectedtag];
}
-(void)didReceiveMemoryWarning
{
    NSLog(@"OBPinPaiViewController--didReceiveMemoryWarning");
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
