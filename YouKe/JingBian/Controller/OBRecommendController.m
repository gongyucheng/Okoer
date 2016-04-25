//
//  OBRecommendController.m
//  YouKe
//
//  Created by obally on 15/7/23.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBRecommendController.h"
#import "HorizontalTableView.h"
#import "OBFooterView.h"
#import "OBContainerViewController.h"
#import <sys/sysctl.h>
#import "OBKWListModel.h"
#import "OBKPListModel.h"
#import "OBRecommendModel.h"
#import "OBKWDataTool.h"
#import "OBKPDataTool.h"
#import "OBVisualEffectView.h"
#import "NSString+Hash.h"
#import "OBOKOerLoginViewController.h"
#import "OBCommentViewController.h"
#import "OBJBKPDataTool.h"
#import <ShareSDK/ShareSDK.h>
#import "OBIDTool.h"

@interface OBRecommendController ()<UIScrollViewDelegate,OBHorizontalTableViewDelegate,OBVisualEffectViewDelegate>{
//    UIImageView *_openImageView;
    UIScrollView *_scrollerView;
    UIImageView *pageImageView;
    MBProgressHUD *_hud;
//    UILabel *_pageLabel
}
@property(nonatomic,retain) HorizontalTableView *horizonTableView;
@property(nonatomic,assign)CGFloat delaytime;
@property (nonatomic, retain)UILabel *totalLabel;
@property (nonatomic, retain)UILabel *pageLabel;
@property (nonatomic, retain) OBVisualEffectView *eff;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) OBKWListModel *kwlistModel;
@property (nonatomic, retain) OBKPListModel *kplistModel;
@property (nonatomic, retain) UIImageView *openImageView;
@property (nonatomic, retain) NSMutableArray *dataModels;
@property (nonatomic, retain) UIImageView *introduceImage;
@property (nonatomic, retain) UIView *introduceView;
@end

@implementation OBRecommendController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"jingbian"];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.openImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:self.openImageView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //手机序列号
//    NSString *dev =  [self doDevicePlatform];
//    NSLog(@"dev = %@",dev);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"backGound.jpg"];
    imageView.userInteractionEnabled = YES;
    
    [self setupTableView];
    
    //2.集成上拉刷新控件
    [self setupUpRefresh];
   
//    [self loadguangGao];
    
}
//- (void)loadguangGao
//{
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    [params setObject:@0 forKey:@"page"];
//    [params setObject:@1 forKey:@"page_rows"];
//    [params setObject:@0 forKey:@"nid"];
//    
//    [OBDataService requestWithURL:OBGuangGaoUrl params:params httpMethod:@"GET" completionblock:^(id result) {
//        [self praseGuanggaoWithResult:result];
//        
//    } failedBlock:^(id error) {
//        
//    }];
//}
//- (void)praseGuanggaoWithResult:(id)result
//{
//    NSArray *array = result[@"data"];
//    if (array.count > 0) {
//        NSInteger y = arc4random() % array.count;
//        NSDictionary *dic = array[y];
//        OBGuangGaoModel *model = [OBGuangGaoModel objectWithKeyValues:dic];
//        model.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.img_uri]]];
//        [OBIDTool saveAccount:model];
//        
//    }
//    
//    
//}

- (void)setupTableView
{
    //2.tableView
    HorizontalTableView *tableView = [[HorizontalTableView alloc]initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KViewHeight(480))];
    imageView.userInteractionEnabled = YES;
//    imageView.alpha = 0;
    UIImageView *centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - KViewWidth(24),KViewHeight(60), KViewWidth(48), KViewHeight(48))];
    [imageView addSubview:centerImage];
    centerImage.transform = CGAffineTransformMakeRotation(-M_PI);
    centerImage.image = [UIImage imageNamed:@"icon_0008_down48"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downTapped)];
    centerImage.userInteractionEnabled = YES;
    [centerImage addGestureRecognizer:tap];
    tableView.tableHeaderView = imageView;
    tableView.horizonTableViewDelegate = self;
    [self.view addSubview:tableView];
    self.horizonTableView = tableView;
    if ([OBJBKPDataTool recommends].count > 0) {
        self.horizonTableView.dataList = [NSMutableArray arrayWithArray:[OBJBKPDataTool recommends]];
        self.totalLabel.text = [NSString stringWithFormat:@"%ld", [OBJBKPDataTool recommends].count];
        [self.horizonTableView reloadData];
    } else
        _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    
     [self performSelector:@selector(delayShowtableView:) withObject:tableView afterDelay:0.35];
}
//点下拉
- (void)downTapped
{
    if (self.dataModels.count > 1) {
        [self.horizonTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        self.horizonTableView.index = 1;
        self.pageLabel.text = @"2";
    }
   
}
//显示动画效果
- (void)delayShowtableView:(UITableView *)tableView
{
    [UIView animateWithDuration:0.35 delay:self.delaytime options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        tableView.y =   10;
    } completion:^(BOOL finished) {
        tableView.y = 0;
        [self.view addSubview:tableView];
        //4.设置呼出资讯恪评按钮
        [self setupCallButton];
        //3.加载数据
        [self loadData];
    }];
    
}
/**
 *   数据加载
 */
- (void)loadData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@0 forKey:@"page"];
    [params setObject:@10 forKey:@"page_rows"];
    
    [OBDataService requestWithURL:OBJBURL params:params httpMethod:@"GET" completionblock:^(id result) {
        if (_hud) {
            [_hud hide:YES];
        }
        
        [self fraseDataWithResult:result];
    } failedBlock:^(id error) {
        if (_hud) {
            [_hud hide:YES];
        }
        if ([OBJBKPDataTool recommends].count > 0) {
            self.horizonTableView.dataList = [NSMutableArray arrayWithArray:[OBJBKPDataTool recommends]];
            self.totalLabel.text = [NSString stringWithFormat:@"%ld", [OBJBKPDataTool recommends].count];
            [self.horizonTableView reloadData];
        }

       [MBProgressHUD showAlert:error];
    }];
}

//数据解析
- (void)fraseDataWithResult:(id)result
{
    NSMutableArray *dataModels = [NSMutableArray array];
    if ([result[@"err_msg"] isEqualToString:@"ok"]) {
        NSArray *dataArray = result[@"data"];
        if (dataArray.count > 0) {
            for (NSDictionary *dic in dataArray) {
                OBRecommendModel *recommendModel = [[OBRecommendModel alloc]init];
                NSString *type = [dic objectForKey:@"type"];
                recommendModel.type = type;
                NSDictionary *dataDic = [dic objectForKey:@"value"];
                if ([type isEqualToString:@"nr"]) {
                    //恪评
                    OBKPListModel *kpModel = [OBKPListModel objectWithKeyValues:dataDic];
                    recommendModel.kpModel = kpModel;
                    
                } else if ([type isEqualToString:@"an"]) {
                    // 资讯
                    OBKWListModel *kwModel = [OBKWListModel objectWithKeyValues:dataDic];
                    recommendModel.kwModel = kwModel;
                }
                
                [dataModels addObject:recommendModel];
               
            }
             [OBJBKPDataTool saveJianBianData:dataModels];
        }
        
    }
    self.dataModels = dataModels;
    self.horizonTableView.dataList = dataModels;
    self.totalLabel.text = [NSString stringWithFormat:@"%ld", self.horizonTableView.dataList.count];
    [self.horizonTableView reloadData];
    //新手介绍
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if (![currentVersion isEqualToString:lastVersion]) {
        UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:view];
        UIImageView *introduce = [[UIImageView alloc]initWithFrame:view.frame];
        introduce.image = [UIImage imageNamed:@"lead1"];
        [view addSubview:introduce];
        self.introduceImage = introduce;
        self.introduceView = view;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(introduceTapAction:)];
        [view addGestureRecognizer:tap];
        
       
    }

}

- (void)tableViewScroll:(HorizontalTableView *)tableView
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastReadPage inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    tableView.index = self.lastReadPage;
    
}

/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    OBFooterView *footer = [[OBFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    footer.hidden = YES;
    self.horizonTableView.tableFooterView = footer;
}
/**
 *  呼出按钮
 */
- (void)setupCallButton
{
    
    pageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - KbuttonWidth - KbuttonEdgeWidth, kScreenHeight - KbuttonWidth - KbuttonEdgeWidth, KbuttonWidth, KbuttonWidth)];
    pageImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)];
    [pageImageView addGestureRecognizer:singleTap];
    pageImageView.layer.cornerRadius = pageImageView.height/2;
    pageImageView.backgroundColor = [UIColor blackColor];
    pageImageView.alpha = 0.7;
    [self.view addSubview:pageImageView];
    __block UILabel *pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,KViewHeight(2), pageImageView.width, pageImageView.height/2)];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.text = [NSString stringWithFormat:@"%d", 1];
    pageLabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    self.pageLabel = pageLabel;
     pageLabel.textColor = HWColor(255, 188, 32);
    if (self.lastReadPage) {
        pageLabel.text = [NSString stringWithFormat:@"%ld",self.lastReadPage + 1];
    }
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), pageImageView.width/2 + KViewWidth(2), pageImageView.width - KViewWidth(10) * 2 , 0.5)];
    line.backgroundColor = [UIColor whiteColor];
    [pageImageView addSubview:line];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,  pageImageView.height/2 , pageImageView.width, pageImageView.height/2)];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.textColor = [UIColor whiteColor];
    if ([OBJBKPDataTool recommends].count > 0) {
        
        self.totalLabel.text = [NSString stringWithFormat:@"%ld", [OBJBKPDataTool recommends].count];
        
    }

    self.totalLabel = totalLabel;
    self.horizonTableView.block =  ^(NSInteger index){
    pageLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
    };

    [pageImageView addSubview:pageLabel];
    [pageImageView addSubview:totalLabel];
    
    
}

//
- (void)photoTapped
{
    if (self.isFirstLoad) {
        OBContainerViewController *containerVC = [[OBContainerViewController alloc]init];
        containerVC.jblastReadPage = self.lastReadPage;
        [self presentViewController:containerVC animated:NO completion:^{
            
        }];
       
    } else {
        
         [self dismissViewControllerAnimated:NO completion:nil];
        
    }

   
}
- (void)introduceTapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    if (point.x >= pageImageView.left - KViewWidth(20) && point.x <= pageImageView.right + KViewWidth(10) && point.y >= pageImageView.top - KViewHeight(20) && point.y <= pageImageView.bottom + KViewHeight(10)) {
        [self.introduceView removeFromSuperview];
        [self photoTapped];
    }
}
#pragma  mark -  增加广告页
- (void)loadOpenView
{
    [MobClick event:@"boot"];
    self.delaytime += 2;
    
    if ([OBIDTool guangGao]) {
        //        self.openImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.openImageView.image = [OBIDTool guangGao].image;
    } else
        self.openImageView.image = [UIImage imageNamed:@"id"];
    
    [self performSelector:@selector(removeLoadOpenView) withObject:nil afterDelay:2];
}
- (void)removeLoadOpenView
{
    [UIView animateWithDuration:1.0 animations:^{
        self.openImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.openImageView removeFromSuperview];
    }];
}

#pragma  mark -  OBHorizontalTableViewDelegate
- (void)tableViewdidSelectedKPMoreButtonWithListModel:(OBKPListModel *)listModel
{
    self.kplistModel = listModel;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    OBVisualEffectView *effview  = [[OBVisualEffectView alloc]initWithFrame:lastWindow.frame];
    self.eff = effview;
    effview.isKePing = YES;
    effview.nid = listModel.nid;
    effview.visualDelegate = self;
    [lastWindow addSubview:effview];
}
- (void)tableViewdidSelectedKWMoreButtonWithListModel:(OBKWListModel *)listModel
{
    self.kwlistModel = listModel;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    OBVisualEffectView *effview  = [[OBVisualEffectView alloc]initWithFrame:lastWindow.frame];
    self.eff = effview;
    effview.isKePing = NO;
    effview.nid = listModel.nid;
//    effview.likeCount = listModel.like_count;
//    effview.commentCount = listModel.comment_count;
    effview.visualDelegate = self;
    [lastWindow addSubview:effview];
}
#pragma mark - OBVisualEffectViewDelegate
- (void)didSelectedCollectionButtonWithSelected:(BOOL)isSelected
{
    
    if ([OBManager sessionManager].status == OBSessionStatusLogin) {
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
        
        if (self.kwlistModel) {
            [params setObject:[NSString stringWithFormat:@"%ld",self.kwlistModel.nid ]forKey:@"nid"];
        } else if (self.kplistModel) {
            [params setObject:[NSString stringWithFormat:@"%ld",self.kplistModel.nid ]forKey:@"nid"];
        }
        
        
        if (isSelected) {
            //点赞
            [OBDataService requestWithURL:OBCollectionURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                 NSNumber *code = result[@"ret_code"];
                NSString *err_msg = result[@"err_msg"];
                if ([code integerValue] == - 9) {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                }else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"收藏成功"];

                } else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }else
                    [MBProgressHUD showAlert:err_msg];
            } failedBlock:^(id error) {
               [MBProgressHUD showAlert:error];
            }];
        } else {
            //取消点赞
            [OBDataService requestWithURL:OBDeCollectionJBURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                NSNumber *code = result[@"ret_code"];
                NSString *err_msg = result[@"err_msg"];
                if ([code integerValue] == - 9){
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"取消收藏"];
                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                } else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }else
                   [MBProgressHUD showAlert:err_msg];
            } failedBlock:^(id error) {
               [MBProgressHUD showAlert:error];
            }];
        }
        
    } else {
        OBOKOerLoginViewController *OKOerVC = [[OBOKOerLoginViewController alloc]init];
        [self presentViewController:OKOerVC animated:YES completion:nil];
    }
    
}

- (void)didSelectedLoveButtonWithSelected:(BOOL)isSelected
{
    if ([OBManager sessionManager].status == OBSessionStatusLogin) {
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
        if (self.kwlistModel) {
            [params setObject:[NSString stringWithFormat:@"%ld",self.kwlistModel.nid ]forKey:@"nid"];
        } else if (self.kplistModel) {
            [params setObject:[NSString stringWithFormat:@"%ld",self.kplistModel.nid ]forKey:@"nid"];
        }
        
        if (isSelected) {
            //点赞
            [OBDataService requestWithURL:OBLIKEURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                NSNumber *code = result[@"ret_code"];
                NSString *err_msg = result[@"err_msg"];
                if ([code integerValue] == - 9) {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"点赞成功"];
                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                } else
                    [MBProgressHUD showAlert:err_msg];
            } failedBlock:^(id error) {
                [MBProgressHUD showAlert:error];
            }];
        } else {
            //取消点赞
            [OBDataService requestWithURL:OBDISLIKEURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                NSNumber *code = result[@"ret_code"];
                NSString *err_msg = result[@"err_msg"];
                if ([code integerValue] == - 9) {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"取消点赞"];
                } else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }else
                    [MBProgressHUD showAlert:err_msg];
            } failedBlock:^(id error) {
                [MBProgressHUD showAlert:error];
            }];
        }
        
    } else {
        OBOKOerLoginViewController *OKOerVC = [[OBOKOerLoginViewController alloc]init];
        [self presentViewController:OKOerVC animated:YES completion:nil];
    }
    
}
- (void)didSelectedCommentButton
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    if (self.kwlistModel) {
        commentVC.pageId = self.kwlistModel.nid;
        commentVC.commentTitle = self.kwlistModel.title;
    } else if (self.kplistModel) {
        commentVC.pageId = self.kplistModel.nid;
        commentVC.commentTitle = self.kplistModel.title;
    }
    [self presentViewController:commentVC animated:YES completion:nil];
}
/**
* //tag = 200 新浪微博分享 201 微信好友 202 微信朋友圈 203 QQ好友
 *        204 QQ空间  205 邮箱
*/
- (void)didSelectedShareButtonWithSelectedShareType:(OBShareType)type
{
    
    
    if (type == OBShareTypeSinaWeibo) {
        [self shareWithShareType:ShareTypeSinaWeibo];
    } else if (type == OBShareTypeWeiXinSession) {
         [self shareWithShareType:ShareTypeWeixiSession];
    }else if (type == OBShareTypeWeixinTimeline) {
         [self shareWithShareType:ShareTypeWeixiTimeline];
    }else if (type == OBShareTypeQQSession) {
         [self shareWithShareType:ShareTypeQQ];
    }else if (type == OBShareTypeQQTimeline) {
         [self shareWithShareType:ShareTypeQQSpace];
    }else if (type == OBShareTypeEmail) {
     [self shareWithShareType:ShareTypeMail];
    }
}

- (void)shareWithShareType:(ShareType)shareType
{
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                      
                                                         allowCallback:NO
                                      
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                      
                                                          viewDelegate:nil
                                      
                                               authManagerViewDelegate:nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                        
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                        
                                                               qqButtonHidden:YES
                                        
                                                        wxSessionButtonHidden:YES
                                        
                                                       wxTimelineButtonHidden:YES
                                        
                                                         showKeyboardOnAppear:NO
                                        
                                                            shareViewDelegate:nil
                                        
                                                          friendsViewDelegate:nil
                                        
                                                        picViewerViewDelegate:nil];
    NSString *imageString;
    NSString *content;
    NSString *urlString;
    NSString *title;
    if (self.kwlistModel) {
        urlString = self.kwlistModel.web_path;
        imageString = self.kwlistModel.img_uri;
        content = self.kwlistModel.summary;
        title = self.kwlistModel.title;
    } else if (self.kplistModel) {
        urlString = self.kplistModel.web_path;
        imageString = self.kplistModel.img_uri;
        content = self.kplistModel.summary;
        title = self.kplistModel.title;
    }
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageString]
                                                title:title
                                                  url:urlString
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    if (shareType == ShareTypeSinaWeibo) {
        NSString *sinaContent = [NSString stringWithFormat:@"%@@优恪网 %@ ", title, urlString];
        publishContent = [ShareSDK content:sinaContent
                            defaultContent:sinaContent
                                     image:[ShareSDK imageWithUrl:imageString]
                                     title:title
                                       url:urlString
                               description:sinaContent
                                 mediaType:SSPublishContentMediaTypeNews];
        if (![ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
            [ShareSDK authWithType:ShareTypeSinaWeibo options:authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
                if (state == SSAuthStateSuccess) {
                    [ShareSDK clientShareContent:publishContent
                                            type:ShareTypeSinaWeibo
                                     authOptions:authOptions
                                    shareOptions:shareOptions
                                   statusBarTips:YES
                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                              if (state == SSPublishContentStateSuccess)
                                              {
                                                  NSString *notice = @"分享成功";
                                                  UIAlertView *view =
                                                  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                             message:notice
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"知道了"
                                                                   otherButtonTitles: nil];
                                                  [view show];
                                              }
                                              else if (state == SSPublishContentStateFail)
                                              {
                                                  NSString *notice = [error errorDescription];
                                                  UIAlertView *view =
                                                  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                             message:notice
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"知道了"
                                                                   otherButtonTitles: nil];
                                                  [view show];
                                                  
                                                  NSLog(NSLocalizedString(@"发布失败!error code == %d, error code == %@", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                              }
                                              
                                          }];
                }
            }];
        } else {// use client share to Sina App Client
            id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"美容总监"
                                                                   shareViewDelegate:nil];
            [ShareSDK clientShareContent:publishContent
                                    type:ShareTypeSinaWeibo
                             authOptions:authOptions
                            shareOptions:shareOptions
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                      if (state == SSPublishContentStateSuccess)
                                      {
                                          NSString *notice = @"分享成功";
                                          UIAlertView *view =
                                          [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:notice
                                                                    delegate:nil
                                                           cancelButtonTitle:@"知道了"
                                                           otherButtonTitles: nil];
                                          [view show];
                                      }
                                      else if (state == SSPublishContentStateFail)
                                      {
                                          NSString *notice = [error errorDescription];
                                          UIAlertView *view =
                                          [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:notice
                                                                    delegate:nil
                                                           cancelButtonTitle:@"知道了"
                                                           otherButtonTitles: nil];
                                          [view show];
                                          
                                          NSLog(NSLocalizedString(@"发布失败!error code == %d, error code == %@", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                      }
                                      
                                  }];
        }
    }else {
        [ShareSDK showShareViewWithType:shareType
                              container:nil
                                content:publishContent
                          statusBarTips:YES
                            authOptions:authOptions
                           shareOptions:shareOptions
                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                     
                                     if (state == SSPublishContentStateSuccess)
                                     {
                                         NSString *notice = @"分享成功";
                                         UIAlertView *view =
                                         [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:notice
                                                                   delegate:nil
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles: nil];
                                         [view show];
                                     }
                                     else if (state == SSPublishContentStateFail)
                                     {
                                         NSString *notice = [error errorDescription];
                                         UIAlertView *view =
                                         [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:notice
                                                                   delegate:nil
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles: nil];
                                         [view show];
                                         
                                         NSLog(NSLocalizedString(@"发布失败!error code == %d, error code == %@", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                     }
                                 }];
        
    }

}
-(void)didReceiveMemoryWarning
{
    NSLog(@"OBRecommendController--didReceiveMemoryWarning");
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
