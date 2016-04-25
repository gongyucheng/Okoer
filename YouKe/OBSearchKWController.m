//
//  OBSearchKWController.m
//  YouKe
//
//  Created by obally on 15/10/29.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import "OBSearchKWController.h"
#import "OBMyCollectionTableView.h"
#import "OBMyCollectionModel.h"
#import "NSString+Hash.h"

@interface OBSearchKWController ()<BaseTableViewDelegate>
{
    MBProgressHUD *_hud;
    NSInteger page;
}
@property (nonatomic, strong) OBMyCollectionTableView *myCollectionTableView;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) NSMutableArray *dataLists;
@property (nonatomic, retain) UIView *placeholderView;
@property (nonatomic, copy) NSString *searchString;
@end

@implementation OBSearchKWController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataLists = [NSMutableArray array];
        self.view.backgroundColor = HWRandomColor;
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)initView
{
    
    //单元格---------------------
    OBMyCollectionTableView *gradetableView = [[OBMyCollectionTableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - KViewHeight(60)) style:UITableViewStylePlain];
    gradetableView.refreshDelegate = self;
    gradetableView.isSearch = YES;
    self.myCollectionTableView = gradetableView;
    [self.view addSubview:gradetableView];
}
- (void)loadDataWithSearchString:(NSString *)searchString
{
    self.myCollectionTableView.scrollEnabled = NO;
    self.searchString = searchString;
     _hud = [MBProgressHUD showHUDAddedTo:self.myCollectionTableView animated:YES];
    NSNumber *pageCount = [NSNumber numberWithInteger:page];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:pageCount forKey:@"page"];
    [params setObject:@6 forKey:@"page_rows"];
    [params setObject:searchString forKey:@"key_word"];
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
    
    NSString *urlString = OBKWURL;
    if ([OBAccountTool account]) {
        urlString = OBSearchKWURL(uid, timeString, sign);
    }
    [OBDataService requestWithURL:urlString params:params httpMethod:@"GET" completionblock:^(id result) {
        self.myCollectionTableView.scrollEnabled = YES;
        [_hud hide:YES];
        NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == - 9){
            NSDictionary *resultDic = result[@"result"];
            NSString *timestamp_offset = resultDic[@"timestamp_offset"];
            self.currentTimeOffset = timestamp_offset;
            [self loadDataWithSearchString:self.searchString];
        } else if ([code integerValue] == 0) {
            [self praseDataWithResult:result];
        } else if ([code integerValue] == - 8) {
            //token 过期
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadDataWithSearchString:)];
        }else if ([code integerValue] == - 24) {
            //签名错误
            [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadDataWithSearchString:)];
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
                //资讯
                collectionModel.type = @"an";
                OBKPListModel *kpModel = [OBKPListModel objectWithKeyValues:dic];
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
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(250))/2, KViewHeight(50), KViewWidth(250), KViewHeight(50))];
            label.text = @"暂时没有为您找到相关资讯文章";
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
    [self loadDataWithSearchString:self.searchString];
}
- (void)pullUp:(BaseTableView *)tableView
{
    [self loadDataWithSearchString:self.searchString];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"OBSearchKWViewControllerdidReceiveMemoryWarning");
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
            NSLog(@" self.view = nil");
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }

}


@end
