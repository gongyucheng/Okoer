//
//  OBAddListView.m
//  YouKe
//
//  Created by obally on 16/1/5.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBAddListView.h"
#import "NSString+Hash.h"
#import "OBMyListModel.h"
#import "NSString+Hash.h"
#import "OBAddNewListView.h"
#import "OBAddListTableView.h"
#import "OBColorRefresh.h"
@interface OBAddListView ()<BaseTableViewDelegate,OBAddListTableViewDelegate> {
    NSInteger page;
    MBProgressHUD *_hud;
}
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) OBAddListTableView *listTable;
@property (nonatomic, retain) NSMutableArray *listArrays;
@property (nonatomic, retain) UIVisualEffectView *visualEffectView;
@property(nonatomic,assign)NSInteger lid;
@property (nonatomic, retain) NSMutableArray *selectedLists;
@property (nonatomic, retain) UIView *noListView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@end
@implementation OBAddListView
- (NSMutableArray *)selectedLists
{
    if (!_selectedLists) {
        self.selectedLists = [[NSMutableArray alloc] init];
    }
    return _selectedLists;
}
- (NSMutableArray *)listArrays
{
    if (!_listArrays) {
        self.listArrays = [[NSMutableArray alloc] init];
    }
    return _listArrays;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewsWithFrame:frame];
        [self loadListData];
        
    }
    return self;
}
-(void)initViewsWithFrame:(CGRect)rect
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    [self addSubview:visualEffect];
    self.visualEffectView = visualEffect;
    visualEffect.frame = rect;
    visualEffect.alpha = 1;
    //返回
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(15), KViewHeight(30), KViewWidth(70), KViewHeight(30))];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    backButton.alpha = 0.6;
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, KViewWidth(10))];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:backButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(150))/2, KViewHeight(30), KViewWidth(150), KViewHeight(30))];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"选择清单";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:KFont(18)];
    [visualEffect addSubview:label];  
    
    OBAddListTableView *listTable = [[OBAddListTableView alloc]initWithFrame:CGRectMake(0, label.bottom + KViewHeight(20), kScreenWidth , kScreenHeight - KViewHeight(200)) style:UITableViewStylePlain];
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTable.backgroundColor = [UIColor clearColor];
    listTable.backgroundView.backgroundColor = [UIColor clearColor];
    listTable.bouncesZoom = NO;
    listTable.addListTableViewDelegate = self;
    listTable.refreshHeaderView.hidden = YES;
    self.listTable = listTable;
    listTable.refreshDelegate = self;
    [visualEffect addSubview:listTable];
    UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadView.frame = CGRectMake((kScreenWidth - KViewWidth(30))/2, (kScreenHeight - KViewWidth(30))/2, KViewWidth(30), KViewHeight(30));
    [self addSubview:loadView];
    [loadView startAnimating];
    self.activityIndicatorView = loadView;
//    _hud = [MBProgressHUD showHUDAddedTo:listTable animated:YES];
    
}
- (void)initNoListView
{
//    self.listTable.refreshFooterButton.hidden = YES;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, KViewHeight(80), kScreenWidth, kScreenHeight - KViewHeight(80))];
    [self.visualEffectView addSubview:view];
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
    [saveButton addTarget:self action:@selector(createButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:saveButton];
}
- (void)initHaveListView
{
    //确定
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(15), kScreenHeight - KViewHeight(110), kScreenWidth - KViewWidth(15) *2, KViewHeight(35))];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    sureButton.backgroundColor = HWColor(31, 167, 86);
    sureButton.layer.cornerRadius = 6;
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.visualEffectView addSubview:sureButton];
    
    //创建清单
    UIButton *createButton = [[UIButton alloc]initWithFrame:CGRectMake(sureButton.left, sureButton.bottom + KViewHeight(10), sureButton.width, KViewHeight(35))];
    [createButton setTitle:@"创建新清单" forState:UIControlStateNormal];
    createButton.backgroundColor = HWColor(51, 51, 51);
    [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [createButton addTarget:self action:@selector(createButton:) forControlEvents:UIControlEventTouchUpInside];
    createButton.layer.cornerRadius = 6;
    createButton.layer.masksToBounds = YES;
    [self.visualEffectView addSubview:createButton];
}
- (void)loadListData
{
    if ([OBAccountTool account]) {
        self.listTable.scrollEnabled = NO;
//        [_hud show:YES];
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
//            [_hud hide:YES];
            [self.activityIndicatorView stopAnimating];
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
                [self loadListData];
            }else if ([code integerValue] == - 8) {
                //token 过期
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadListData)];
            }else if ([code integerValue] == - 24) {
                //签名错误
                [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(loadListData)];
            }else if ([code integerValue] == - 26) {
                //已存在
                [MBProgressHUD showAlert:@"清单已存在"];
            }
            
        } failedBlock:^(id error) {
             self.listTable.scrollEnabled = YES;
            [self.activityIndicatorView stopAnimating];
//            [_hud hide:YES];
            [MBProgressHUD showAlert:error];
        }];
        
    }

}
- (void)praseDataWithResult:(id)result
{
    NSArray *dataArrays = result[@"data"];
    if (dataArrays.count > 0) {
        [self initHaveListView];
        NSArray *listModels = [OBMyListModel objectArrayWithKeyValuesArray:dataArrays];
        [self.listArrays addObjectsFromArray:listModels];
        self.listTable.listArrays = self.listArrays;
        [self.listTable reloadData];
        if (listModels.count >= 10) {
            self.listTable.refreshFooter = YES;
        } else {
            self.listTable.refreshFooter = NO;
        }

    }
   

    if (self.listArrays.count ==0) {
        //暂无清单
        [self initNoListView];
    }
    
    page ++;
    
}
- (void)createButton:(UIButton *)createButton
{
//    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [UIApplication sharedApplication].keyWindow;
    OBAddNewListView *effview  = [[OBAddNewListView alloc]initWithFrame:lastWindow.frame];
    effview.addSuccessBlock = ^(OBMyListModel *listModel) {
        self.lid = listModel.lid;
        listModel.isSelected = YES;
        if (self.listArrays.count == 0) {
            [self.listArrays addObject:listModel];
        } else
            [self.listArrays insertObject:listModel atIndex:0];
        self.listTable.listArrays = self.listArrays;
//        self.listTable.haveInsert = YES;
//        self.listTable.number = ++number;
        
        if (self.listArrays.count > 1) {
            [self.listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [self.listTable reloadData];
        [self.listTable layoutIfNeeded];
        if (self.noListView) {
            [self initHaveListView];
            [self.noListView removeFromSuperview];
        }
//        UITableViewCell *cell = [self.listTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//        UIButton *button = (UIButton *)[cell viewWithTag:100];
//        
//        button.selected = YES;
        if (![self.selectedLists containsObject:[NSNumber numberWithInteger:listModel.lid]]) {
            [self.selectedLists addObject:[NSNumber numberWithInteger:listModel.lid]];
        }
    };
    [lastWindow addSubview:effview];
}

- (void)backButton:(UIButton *)createButton
{
    [self removeFromSuperview];
}

//- (void)setPid:(NSInteger )pid
//{
//    _pid = pid;
//    [self loadListData];
//}

- (void)sureButton:(UIButton *)button
{
    if (self.selectedLists.count > 0) {
        [self.activityIndicatorView startAnimating];
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
            NSArray *array = @[[NSNumber numberWithInteger:self.pid]];
            NSString *pidsString = [array componentsJoinedByString:@","];
            NSString *lidsString = [self.selectedLists componentsJoinedByString:@","];
//            NSMutableString *lidString = @"";
//            for (NSNumber *number in self.selectedLists) {
//               NSInteger lid =  [number integerValue];
//                [lidString appendString:[NSString stringWithFormat:@"%ld",lid]];
//            }
            [params setObject:lidsString forKey:@"lids"];
            [params setObject:pidsString forKey:@"pids"];
            [OBDataService requestWithURL:OBAddToListUrl(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                [self.activityIndicatorView stopAnimating];
                NSNumber *code = result[@"ret_code"];
                NSString *message = result[@"err_msg"];
                if ([code integerValue] == 0) {
                    [MBProgressHUD showAlert:@"添加成功"];
                    [self removeFromSuperview];
                }else if ([code integerValue] == -18) {
                    message = result[@"result"];
                    [MBProgressHUD showAlert:message];
                } else if ([code integerValue] == - 9){
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self sureButton:button];
                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(sureButton:)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(sureButton:)];
                }
                
            } failedBlock:^(id error) {
                [MBProgressHUD showAlert:error];
            }];
            
        }

    } else{
        [MBProgressHUD showAlert:@"请选择清单"];
    }
    
}
#pragma mark - BaseTableView delegate
- (void)pullDown:(BaseTableView *)tableView
{
    page = 0;
    if (self.listArrays.count > 0) {
        [self.listArrays removeAllObjects];
    }
    
    [self loadListData];
}

- (void)pullUp:(BaseTableView *)tableView
{
    if (self.listTable.refreshFooter == YES) {
         [self loadListData];
    }else
        self.listTable.refreshFooter = NO;
   
}
- (void)didSelectedAddListTableViewWithIndexPath:(NSIndexPath *)indexpath
{
    UITableViewCell *cell = [self.listTable cellForRowAtIndexPath:indexpath];
    UIButton *button = (UIButton *)[cell viewWithTag:100];
    button.selected = !button.selected;
    if (self.listArrays.count > indexpath.row) {
        OBMyListModel *listModel = self.listArrays[indexpath.row];
        if (button.selected) {
            self.lid = listModel.lid;
            listModel.isSelected = YES;
            if (![self.selectedLists containsObject:[NSNumber numberWithInteger:listModel.lid]]) {
                [self.selectedLists addObject:[NSNumber numberWithInteger:listModel.lid]];
            }
            
        } else {
            listModel.isSelected = NO;
            if ([self.selectedLists containsObject:[NSNumber numberWithInteger:listModel.lid]]) {
                [self.selectedLists removeObject:[NSNumber numberWithInteger:listModel.lid]];
            }
            
        }
    }

}
@end
