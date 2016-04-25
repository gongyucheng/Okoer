//
//  OBKePingViewController.m
//  YouKe
//
//  Created by obally on 15/7/29.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKePingViewController.h"
#import "OBKePingTableView.h"
//#import "MBProgressHUD+FTCExtension.h"
#import "OBKPListModel.h"
#import "OBKPDataTool.h"
#import "OBVisualEffectView.h"
#import "NSString+Hash.h"
#import "OBOKOerLoginViewController.h"
#import "OBCommentViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface OBKePingViewController ()<BaseTableViewDelegate,OBKePingTableViewDelegate,OBVisualEffectViewDelegate>
{
    MBProgressHUD *_hud;
    NSInteger page;

}
@property (nonatomic, retain) OBKePingTableView *kpTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) OBKPListModel *listModel;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) OBVisualEffectView *eff;

@end

@implementation OBKePingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
//    self.view.backgroundColor = HWRandomColor;
    [self initViews];
//    [OBKPDataTool deleSql];
   
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    CGFloat height;
    if (ios7) {
        height = 0;
    } else
        height = 20;
    OBKePingTableView *tableView = [[OBKePingTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KViewHeight(60) + height) style:UITableViewStylePlain];
    tableView.refreshDelegate = self;
    self.kpTableView = tableView;
    tableView.kpTableViewDelegate = self;
    tableView.refreshFooterButton.hidden = NO;
    [self.view addSubview:tableView];
    if ([OBKPDataTool listModels].count > 0) {
        self.kpTableView.dataList = [OBKPDataTool listModels];
        [self.kpTableView reloadData];
    }
    
}

- (void)loadData
{
    self.kpTableView.scrollEnabled = NO;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSNumber *pageCount = [NSNumber numberWithInteger:page];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:pageCount forKey:@"page"];
    [params setObject:@6 forKey:@"page_rows"];
    [OBDataService requestWithURL:OBKPURL params:params httpMethod:@"GET" completionblock:^(id result) {
        self.kpTableView.scrollEnabled = YES;
        if (_hud) {
            [_hud hide:YES];
        }
        [self parseDataFromResult:result];
       
    } failedBlock:^(id error) {
        [_hud hide:YES afterDelay:2];
        self.kpTableView.scrollEnabled = YES;
        if ([OBKPDataTool listModels].count > 0) {
            self.kpTableView.dataList = [OBKPDataTool listModels];
            [self.kpTableView reloadData];
        }
        [MBProgressHUD showAlert:error];

    }];
   
}

- (void)parseDataFromResult:(id)result
{
    NSArray *datas = result[@"data"];
    if (datas.count > 0) {
        NSArray *listArray = [OBKPListModel objectArrayWithKeyValuesArray:result[@"data"]];
        [self.dataArray addObjectsFromArray:listArray];
        self.kpTableView.dataList = self.dataArray;
        [self.kpTableView reloadData];
        if (listArray.count >= 6) {
            self.kpTableView.refreshFooter = YES;
        } else {
            self.kpTableView.refreshFooter = NO;
        } 
        for (OBKPListModel *listModel in self.dataArray) {
            if (![OBKPDataTool isSameListModelWithModel:listModel]) {
                [OBKPDataTool addListModel:listModel];
            }
            
        }
    } else
        self.kpTableView.refreshFooter = NO;
    
     page ++;
}

- (void)pullDown:(BaseTableView *)tableView
{
    page = 0;
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    if ([OBManager sessionManager].mode == OBSessionModeOnline) {
        [OBKPDataTool deleSql];
    }
    [self loadData];
}

- (void)pullUp:(BaseTableView *)tableView
{
    [self loadData];
}
#pragma mark - OBKePingTableViewDelegate
- (void)tableViewdidSelectedMoreButtonWithListModel:(OBKPListModel *)listModel
{
    self.listModel = listModel;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    OBVisualEffectView *effview  = [[OBVisualEffectView alloc]initWithFrame:lastWindow.frame];
    self.eff = effview;
    effview.isKePing = YES;
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
        
        [params setObject:[NSString stringWithFormat:@"%ld",self.listModel.nid ]forKey:@"nid"];
        
        if (isSelected) {
            //点赞
            [OBDataService requestWithURL:OBCollectionURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                NSNumber *code = result[@"ret_code"];
                if ([code integerValue] == - 9) {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {


                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedCollectionButtonWithSelected:)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedCollectionButtonWithSelected:)];
                }
            } failedBlock:^(id error) {
                [MBProgressHUD showAlert:error];

            }];
        } else {
            //取消点赞
            [OBDataService requestWithURL:OBDeCollectionJBURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
//                NSString *err_msg = result[@"err_msg"];
                 NSNumber *code = result[@"ret_code"];
                if ([code integerValue] == - 9) {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"取消收藏"];
                    self.eff.likeCount =_listModel.like_count;
                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedCollectionButtonWithSelected:)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedCollectionButtonWithSelected:)];
                }
            } failedBlock:^(id error) {
                [MBProgressHUD showAlert:error];

            }];
        }
        
    } else {
        OBOKOerLoginViewController *OKOerVC = [[OBOKOerLoginViewController alloc]init];
        [self.view.kewenAndKePingController.navigationController pushViewController:OKOerVC animated:YES];
//        [self.view.containerViewController presentViewController:OKOerVC animated:YES completion:nil];
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
        
        [params setObject:[NSString stringWithFormat:@"%ld",self.listModel.nid ]forKey:@"nid"];
        
        if (isSelected) {
            //点赞
            [OBDataService requestWithURL:OBLIKEURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                NSNumber *code = result[@"ret_code"];
                if ([code integerValue] == - 9){
                    //时间戳过期
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {

                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }
            } failedBlock:^(id error) {
                [MBProgressHUD showAlert:error];

            }];
        } else {
            //取消点赞
            [OBDataService requestWithURL:OBDISLIKEURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                NSNumber *code = result[@"ret_code"];
                if ([code integerValue] == - 9) {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {

                    self.eff.likeCount =_listModel.like_count;
                }else if ([code integerValue] == - 8) {
                    //token 过期
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }else if ([code integerValue] == - 24) {
                    //签名错误
                    [OBTokenExpired tokenExPiredWithControllerTarget:self WithSelector:@selector(didSelectedLoveButtonWithSelected:)];
                }
            } failedBlock:^(id error) {
//                [KLToast showToast:error];
                [MBProgressHUD showAlert:error];

            }];
        }
        
    } else {
        OBOKOerLoginViewController *OKOerVC = [[OBOKOerLoginViewController alloc]init];
        [self.view.kewenAndKePingController.navigationController pushViewController:OKOerVC animated:YES];
//        [self.view.containerViewController presentViewController:OKOerVC animated:YES completion:nil];
    }
    
}
- (void)didSelectedCommentButton
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = self.listModel.nid;
    commentVC.commentTitle = self.listModel.title;
    [self.view.kewenAndKePingController.navigationController pushViewController:commentVC animated:YES];
//    [self.view.containerViewController presentViewController:commentVC animated:YES completion:nil];
}
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
                                      
                                                         allowCallback:YES
                                      
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
    urlString = self.listModel.web_path;
    imageString = self.listModel.img_uri;
    content = self.listModel.summary;
    title = self.listModel.title;
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK imageWithUrl:imageString]
                                                title:title
                                                  url:urlString
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    [publishContent addSinaWeiboUnitWithContent:content image:[ShareSDK imageWithUrl:imageString]];
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
    NSLog(@"OBKePingViewController--didReceiveMemoryWarning");
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
