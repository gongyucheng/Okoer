//
//  OBSearchProductController.m
//  YouKe
//
//  Created by obally on 15/10/29.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import "OBSearchProductController.h"
#import "OBGradeTableView.h"
#import "OBGradeModel.h"
#import "NSString+Hash.h"

@interface OBSearchProductController ()<BaseTableViewDelegate>
{
    MBProgressHUD *_hud;
    NSInteger page;
}
@property (nonatomic, strong) OBGradeTableView *gradeTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *searchString;
@property (nonatomic, retain) UIView *placeholderView;
@property(nonatomic,copy)NSString *currentTimeOffset;
@end

@implementation OBSearchProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HWRandomColor;
    self.dataArray = [NSMutableArray array];
    [self initTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    NSLog(@"OBSearchProductControllerdidReceiveMemoryWarning");
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
- (void)initTableView
{
    //单元格---------------------
    OBGradeTableView *gradetableView = [[OBGradeTableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - KViewHeight(60)) style:UITableViewStylePlain];
    gradetableView.refreshDelegate = self;
    gradetableView.isSearchVC = YES;
    self.gradeTableView = gradetableView;
    
    [self.view addSubview:gradetableView];
}
- (void)loadDataWithSearchString:(NSString *)searchString
{
    self.gradeTableView.scrollEnabled = NO;
    self.searchString = searchString;
     _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    
    NSString *urlString = OBProductReportListURL;
    if ([OBAccountTool account]) {
        urlString = OBSearchProductListURL(uid, timeString, sign);
    }

    [OBDataService requestWithURL:urlString params:params httpMethod:@"GET" completionblock:^(id result) {
        self.gradeTableView.scrollEnabled = YES;
        [_hud hide:YES];
        [self praseDataWithResult:result];
    } failedBlock:^(id error) {
        self.gradeTableView.scrollEnabled = YES;
        [_hud hide:YES afterDelay:2];
        [MBProgressHUD showAlert:@"网络连接失败"];
        //        [KLToast showToast:error];
    }];

    
}

- (void)praseDataWithResult:(id)result
{
    NSString *errmsg = result[@"err_msg"];
    if ([errmsg isEqualToString:@"ok"]) {
        NSArray *dataArray = result[@"data"];
        if (dataArray.count > 0) {
            self.gradeTableView.refreshFooterButton.hidden = NO;
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
            if (self.placeholderView) {
                [self.placeholderView removeFromSuperview];
                self.placeholderView = nil;
            }

        } else if(self.dataArray.count ==0){
//             self.gradeTableView.refreshFooter = NO;
            UIView *view2 = [[UIView alloc]initWithFrame:self.gradeTableView.frame];
            [self.view addSubview:view2];
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(250))/2, KViewHeight(50), KViewWidth(250), KViewHeight(50))];
            label.text = @"暂时没有为您找到相关商品";
            label.textAlignment = NSTextAlignmentCenter;
            self.placeholderView = view2;
            [view2 addSubview:label];
        }else if (dataArray.count == 0) {
            self.gradeTableView.refreshFooter = NO;
        }
    }else
        self.gradeTableView.refreshFooter = NO;
    
    page ++;
}

- (void)pullDown:(BaseTableView *)tableView
{
    page = 0;
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self loadDataWithSearchString:self.searchString];
}

- (void)pullUp:(BaseTableView *)tableView
{
    [self loadDataWithSearchString:self.searchString];
}

@end
