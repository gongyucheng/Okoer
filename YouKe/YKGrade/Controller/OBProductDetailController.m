

//
//  OBProductDetailController.m
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBProductDetailController.h"
#import "MBProgressHUD.h"
#import "OBProductDetailModel.h"
#import "OBSingleColorView.h"
#import "OBShareVisualEffectView.h"
#import <ShareSDK/ShareSDK.h>
#import "OBRankTool.h"
#import "OBRankModel.h"
#import "RegexKitLite.h"
#import "OBPhotoBrowser.h"
#import "OBPhoto.h"
#import "OBGradeListController.h"
#import "OBSingleBrandViewController.h"
#import "OBAddListView.h"
#import "OBLoginViewController.h"

@interface OBProductDetailController ()<UIScrollViewDelegate,OBShareVisualEffectViewDelegate>
{
    MBProgressHUD *_hud;
}
@property (nonatomic, retain) OBProductDetailModel *model;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property(nonatomic,retain)UIScrollView *rootScrollView;
@property(nonatomic,retain)UIImageView *topImageView;
@property (nonatomic, retain)OBShareVisualEffectView *shareEffectView;
@property (nonatomic, retain) NSMutableArray *photoArrays;
@end

@implementation OBProductDetailController
- (NSMutableArray *)photoArrays
{
    if (!_photoArrays) {
        self.photoArrays = [[NSMutableArray alloc] init];
    }
    return _photoArrays;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick event:@"brand" attributes:@{@"brandId":[NSString stringWithFormat:@"%ld",(long)self.rid]}];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self initTopView];
    
}
- (void)initTopView
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
    [backButton setImage:[UIImage imageNamed:@"u215"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:backButton];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(15), KViewWidth(200), KViewHeight(40))];
    titleLabel.textColor = HWColor(31, 167, 86);
    titleLabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"商品详情";
    [visualEffect addSubview:titleLabel];
    //优品
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(35), KViewHeight(25), KViewWidth(24), KViewHeight(24))];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"icon_0000_share20_9"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(visualShareButton) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:shareButton];
}
- (void)initViews
{
    
    //UIScrollView
    UIScrollView *rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.effectView.bottom, kScreenWidth, kScreenHeight - KViewHeight(60))];
     [self.view addSubview:rootScrollView];
    rootScrollView.contentSize = CGSizeMake(kScreenWidth, KViewHeight(200));
    rootScrollView.delegate = self;
    rootScrollView.showsVerticalScrollIndicator = YES;
    rootScrollView.showsHorizontalScrollIndicator = YES;
    self.rootScrollView = rootScrollView;
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KViewHeight(40), kScreenWidth, KViewHeight(150))];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    topImageView.userInteractionEnabled = YES;
    self.topImageView = topImageView;
    [topImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
    [rootScrollView addSubview:topImageView];
//    [self.photoArrays addObject:self.model.pic_uri];
    OBPhoto *photo = [[OBPhoto alloc]init];
    photo.urlString = self.model.pic_uri;
    [self.photoArrays addObject:photo];
    
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTapGesture)];
    [topImageView addGestureRecognizer:tap];
    
    UIButton *gradeLabel = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(5), topImageView.bottom + KViewHeight(40), KViewWidth(50), KViewHeight(50))];
    [gradeLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    OBRankModel *rankModel = [OBRankTool rankModelWithRankId:self.model.rank_id];
    [gradeLabel setTitle:rankModel.name forState:UIControlStateNormal];
    [gradeLabel setBackgroundColor:rankModel.color];
    gradeLabel.titleLabel.font = [UIFont systemFontOfSize:KFont(17.0)];
    [rootScrollView addSubview:gradeLabel];
    
    UILabel *productName = [[UILabel alloc]initWithFrame:CGRectMake(gradeLabel.right + KViewWidth(10), gradeLabel.top, kScreenWidth - KViewWidth(60), KViewHeight(50))];
    productName.textColor = [UIColor blackColor];
    productName.font = [UIFont systemFontOfSize:KFont(17.0)];
    productName.text = self.model.name;
    productName.numberOfLines = 0;
    [rootScrollView addSubview:productName];
    
    UILabel *greenlabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), productName.bottom + KViewHeight(3), kScreenWidth - KViewWidth(10), 1)];
    greenlabel.backgroundColor = HWColor(31, 167, 86);
    [rootScrollView addSubview:greenlabel];
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.contentSize.height + KViewHeight(60))];
    
    UIView *view = [self createViewWithFrame:CGRectMake(0, greenlabel.bottom + 2, kScreenWidth, KViewHeight(50)) TitleName:@"品牌" andContent:self.model.b_name color:HWColor(31, 167, 86) isAction:YES];
    view.tag = 2015;
    [self.rootScrollView addSubview:view];
    UIView *view1 = [self createViewWithFrame:CGRectMake(0, view.bottom + 2, kScreenWidth, KViewHeight(50)) TitleName:@"种类" andContent:self.model.c_title color:HWColor(31, 167, 86) isAction:YES];
    view1.tag = 2016;
    [self.rootScrollView addSubview:view1];
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, view1.bottom, kScreenWidth, KViewHeight(15))];
    grayView.backgroundColor = HWColor(240, 240, 240);
    [self.rootScrollView addSubview:grayView];
    UIView *view2 = [self createViewWithFrame:CGRectMake(0, grayView.bottom + 2, kScreenWidth, KViewHeight(50)) TitleName:@"原名" andContent:self.model.namede color:[UIColor blackColor] isAction:NO];
    [self.rootScrollView addSubview:view2];
    UIView *view3 = [self createViewWithFrame:CGRectMake(0, view2.bottom + 2, kScreenWidth, KViewHeight(50)) TitleName:@"总评" andContent:[NSString stringWithFormat:@"%@(%@)",rankModel.name,rankModel.chineseName] color:[UIColor blackColor] isAction:NO];
    [self.rootScrollView addSubview:view3];
    UIView *view4 = [self createViewWithFrame:CGRectMake(0, view3.bottom + 2, kScreenWidth, KViewHeight(50))TitleName:@"出处" andContent:self.model.source color:[UIColor blackColor] isAction:NO];
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.size.height + KViewHeight(200))];
    [self.rootScrollView addSubview:view4];
    
    //  检测数据
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), view4.bottom + 20, KViewWidth(200), KViewHeight(40))];
    label.text = @"检测数据";
    label.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    label.textColor = [UIColor blackColor];
    [self.rootScrollView addSubview:label];
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.contentSize.height + KViewHeight(60))];
    UILabel *greenlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5),label.bottom + KViewHeight(10), kScreenWidth - KViewWidth(10), 1)];
    greenlabel1.backgroundColor = HWColor(31, 167, 86);
    [rootScrollView addSubview:greenlabel1];
    CGFloat height = greenlabel1.bottom;
    CGFloat totalheight = 0;
    for (int i = 0; i < self.model.parameters.count; i ++) {
        NSDictionary *dic = self.model.parameters[i];
        UIView *view = [self createViewWithFrame:CGRectMake(0, height, kScreenWidth, KViewHeight(50)) TitleName:dic[@"key"] andContent:dic[@"value"] color:[UIColor blackColor] isAction:NO];
         [self.rootScrollView addSubview:view];
        height += view.height;
        totalheight += view.height;
       
    }
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.size.height + self.model.parameters.count * KViewHeight(50) + KViewHeight(60))];
    CGFloat offSet = totalheight -  self.model.parameters.count * KViewHeight(50);
    //  采购说明
    UILabel *buylabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), height + KViewHeight(20), KViewWidth(200), KViewHeight(40))];
    buylabel.text = @"采购说明";
    buylabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    buylabel.textColor = [UIColor blackColor];
    [self.rootScrollView addSubview:buylabel];
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.contentSize.height + KViewHeight(60) + KViewWidth(offSet))];
    
    UILabel *greenlabel2 = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5),buylabel.bottom + KViewHeight(10), kScreenWidth - KViewWidth(10), 1)];
    greenlabel2.backgroundColor = HWColor(31, 167, 86);
    [rootScrollView addSubview:greenlabel2];
    UILabel *buydetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(12), greenlabel2.bottom + KViewHeight(10), kScreenWidth - KViewWidth(10) * 2, KViewHeight(40))];
//    buydetailLabel.backgroundColor = HWColor(31, 167, 86);
    buydetailLabel.textColor = [UIColor blackColor];
    buydetailLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    NSString *regex = @"\\<br\\>";
    NSArray *arrays = [self.model.product_buy_details componentsMatchedByRegex:regex];
    buydetailLabel.text = self.model.product_buy_details;
    for (NSString *br in arrays) {
        
        //替换：将<br> 替换成空
        buydetailLabel.text = [self.model.product_buy_details stringByReplacingOccurrencesOfString:br withString:@""];
    }

    buydetailLabel.numberOfLines = 0;
    buydetailLabel.textAlignment = NSTextAlignmentLeft;
    //设置内容的间距
    NSMutableAttributedString * attributedString2 =[NSString attributedStringWithText:buydetailLabel.text WithLineSpace:KViewHeight(5)];
    [buydetailLabel setAttributedText:attributedString2];
    buydetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = buydetailLabel.font;
    attrs[NSKernAttributeName] =[NSNumber numberWithFloat:KViewHeight(5)];
    CGRect buydetailLabelSize = [buydetailLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - KViewWidth(20), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                             NSStringDrawingUsesLineFragmentOrigin |
                                 NSStringDrawingUsesFontLeading attributes:attrs context:nil];
    buydetailLabel.height = buydetailLabelSize.size.height + KViewHeight(20);
    [rootScrollView addSubview:buydetailLabel];
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.contentSize.height + buydetailLabel.height + KViewHeight(20))];
    
    //采购时间
    UILabel *buytime = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), buydetailLabel.bottom + KViewHeight(20), KViewWidth(200), KViewHeight(40))];
    buytime.text = @"采购时间";
    buytime.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    buytime.textColor = [UIColor blackColor];
    [self.rootScrollView addSubview:buytime];
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.contentSize.height + KViewHeight(60))];
    
    UILabel *greenlabel3 = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5),buytime.bottom + KViewHeight(10), kScreenWidth - KViewHeight(10), 1)];
    greenlabel3.backgroundColor = HWColor(31, 167, 86);
    [rootScrollView addSubview:greenlabel3];
    UILabel *buyTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, greenlabel3.bottom + KViewHeight(10), kScreenWidth - 10, 40)];
    //    buydetailLabel.backgroundColor = HWColor(31, 167, 86);
    buyTimeLabel.textColor = [UIColor blackColor];
    buyTimeLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    buyTimeLabel.text = self.model.product_buy_time;
    buyTimeLabel.numberOfLines = 0;
    buyTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.rootScrollView addSubview:buyTimeLabel];
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.contentSize.height + KViewHeight(60))];

    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), buyTimeLabel.bottom + KViewHeight(30), kScreenWidth - KViewHeight(10), KViewHeight(40))];
    //    buydetailLabel.backgroundColor = HWColor(31, 167, 86);
    bottomLabel.textColor =  HWColor(153, 153, 153);
    bottomLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    bottomLabel.text = @"查阅更详细的检测报告，请登录OKOer.com";
    bottomLabel.numberOfLines = 0;
    bottomLabel.textAlignment = NSTextAlignmentLeft;
    [self.rootScrollView addSubview:bottomLabel];
    [self.rootScrollView setContentSize:CGSizeMake(kScreenWidth, self.rootScrollView.contentSize.height + KViewHeight(80))];
    
    //优品
    UIButton *addListButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(56), kScreenHeight - KViewHeight(56), KViewWidth(46), KViewHeight(46))];
    [addListButton setBackgroundImage:[UIImage imageNamed:@"addIcoon"] forState:UIControlStateNormal];
    [addListButton addTarget:self action:@selector(addListButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addListButton];
    
}

- (void)loadData
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.dimBackground = YES;
    NSString *urlString = OBProductDetailUrl(self.rid);
    [OBDataService requestWithURL:urlString params:nil httpMethod:@"GET" completionblock:^(id result) {
        [_hud hide:YES];
        [self praseDataWithResult:result];
    } failedBlock:^(id error) {
        [_hud hide:YES afterDelay:2];
        [MBProgressHUD showAlert:error];
    }];

}

- (void)photoTapGesture
{
    
    OBPhotoBrowser *brower = [[OBPhotoBrowser alloc]init];
    NSInteger index = 0;
    brower.currentPhotoIndex = index;
    
    brower.photos = self.photoArrays;
    [brower show];
}

- (void)praseDataWithResult:(id)result
{
    NSString *errmsg = result[@"err_msg"];
    if ([errmsg isEqualToString:@"ok"]) {
//        NSDictionary *dic = result[@"data"];
        OBProductDetailModel *model = [OBProductDetailModel objectWithKeyValues:result];
        self.model = model;
        [self initViews];
    }

}

- (UIView *)createViewWithFrame:(CGRect)rect TitleName:(NSString *)titleName andContent:(NSString *)content color:(UIColor*)color isAction:(BOOL)isAction
{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10),KViewHeight(15), KViewWidth(30), KViewHeight(30))];
    titleLabel.textColor = HWColor(153, 153, 153);
    titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    titleLabel.text = titleName;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    CGRect titleLabelSize = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth/2 - KViewWidth(10), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                             NSStringDrawingUsesLineFragmentOrigin |
                             NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(14.0)]} context:nil];
    titleLabel.width = titleLabelSize.size.width;
    titleLabel.height = titleLabelSize.size.height;
    view.height = view.height > (titleLabelSize.size.height + KViewHeight(30))?view.height :(titleLabelSize.size.height + KViewHeight(30));
    [view addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right + KViewWidth(10),titleLabel.top, KViewWidth(30), KViewHeight(30))];
//    contentLabel.backgroundColor = HWColor(204, 204, 204);
    contentLabel.textColor = color;
    contentLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    CGRect contentLabelSize = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - titleLabel.width - KViewHeight(20), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                             NSStringDrawingUsesLineFragmentOrigin |
                             NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(14.0)]} context:nil];
    contentLabel.width = contentLabelSize.size.width;
    contentLabel.height = contentLabelSize.size.height;
    titleLabel.top = contentLabel.top;
    view.height = view.height > (contentLabelSize.size.height + KViewHeight(30))?view.height :(contentLabelSize.size.height + KViewHeight(30));
    [view addSubview:contentLabel];
    UILabel *grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), view.height - 0.5, kScreenWidth - KViewWidth(5), 0.5)];
    grayLabel.alpha = 0.8;
    grayLabel.backgroundColor = HWColor(240, 240, 240);
    [view addSubview:grayLabel];
    if (isAction) {
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(view.right - KViewHeight(50) , view.height/2 - KViewWidth(16) , KViewWidth(26), KViewHeight(26))];
        arrowImage.image = [UIImage imageNamed:@"icon_0001_right26_9.png"];
        [view addSubview:arrowImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        [view addGestureRecognizer:tap];
    }
    return view;
}
- (void)tapGestureAction:(UITapGestureRecognizer *)reg
{
    if (reg.view.tag == 2015) {
        //品牌
        OBGradeListController *listVC = [[OBGradeListController alloc]init];
        listVC.brandtitle = self.model.b_name;
        listVC.brandId = self.model.bid;
        [self.navigationController pushViewController:listVC animated:YES];
//        [self presentViewController:listVC animated:YES completion:nil];
        
    } else if (reg.view.tag == 2016) {
        //种类
        OBSingleBrandViewController *singleVC = [[OBSingleBrandViewController alloc]init];
        singleVC.cid = self.model.cid;
        singleVC.ctitle = self.model.c_title;
        [self.navigationController pushViewController:singleVC animated:YES];
//        [self presentViewController:singleVC animated:YES completion:nil];
    }
}
- (void)visualShareButton
{
//    self.listModel = listModel;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    OBShareVisualEffectView *effview  = [[OBShareVisualEffectView alloc]initWithFrame:lastWindow.frame];
    effview.shareVisualDelegate = self;
    self.shareEffectView = effview;
    [lastWindow addSubview:effview];
}
- (void)addListButton
{
    if ([OBAccountTool account]) {
        UIWindow *lastWindow = [UIApplication sharedApplication].keyWindow;
        OBAddListView *effview  = [[OBAddListView alloc]initWithFrame:lastWindow.frame];
        effview.pid = self.pid;
        [lastWindow addSubview:effview];
    }else
    {
        OBLoginViewController *login = [[OBLoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}
- (void)backButton
{
    NSLog(@"%@-----------",self.navigationController);
    NSLog(@"%@-----------",self.navigationController.viewControllers);
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)shareVisualDidSelectedShareButtonWithSelectedShareType:(OBShareType)type
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
    [ShareSDK cancelAuthWithType:shareType];
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
    urlString = self.model.web_path;
    imageString = self.model.pic_uri;
    content = self.model.summary;
    title = self.model.name;
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
    NSLog(@"OBProductDetailController--didReceiveMemoryWarning");
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
