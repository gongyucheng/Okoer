 //
//  OBKPDetailViewController.m
//  YouKe
//
//  Created by obally on 15/8/5.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKPDetailViewController.h"
#import "OBDetailBottomView.h"
#import "OBChatRoomController.h"
#import "OBKPDetailModel.h"
#import "OBGuangGaoModel.h"
#import "OBKPListModel.h"
#import "OBKPRelatedCardView.h"
#import "OBBottomBackView.h"
#import "OBVisualEffectView.h"
#import "NSString+Hash.h"
#import "OBOKOerLoginViewController.h"
#import "OBCommentViewController.h"
#import "OBDetailReportViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "NSString+Extension.h"
#import "RegexKitLite.h"
#import "OBPhotoBrowser.h"
#import "OBPhoto.h"
#define kImageOriginHight kScreenWidth
@interface OBKPDetailViewController ()<UIScrollViewDelegate,OBKPRelatedCardViewDelegate,OBBottomBackViewDelegate,OBVisualEffectViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    MBProgressHUD *_hud;
    BOOL isFirst;
    NSInteger _lastPosition;
    BOOL isfinishLoadWeb;
}
@property (nonatomic, retain) UILabel *categoryLabel;
@property (nonatomic, retain) UIImageView *topImage;
@property (nonatomic, retain) UIImageView *maskView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, retain) UIWebView *webView; //内容webView
@property (nonatomic, retain) UIWebView *imagewebView; //图片webView
@property (nonatomic, retain) UIScrollView *scrollerView;
@property (nonatomic, retain) OBKPDetailModel *detailModel;
@property (nonatomic, retain) OBGuangGaoModel *guangGaoModel;
@property (nonatomic, retain) OBKPListModel *kpListModel;
@property (nonatomic, retain) OBBottomBackView *backView;
@property (nonatomic, retain) OBVisualEffectView *eff;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) UILabel *grayLabel;
@property (nonatomic,retain)NSMutableArray *picUrlArray; //所有图片
@property (nonatomic,retain)NSMutableArray *photoArrays; //OBPhoto对象
@end

@implementation OBKPDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
     [MobClick event:@"reportpv" attributes:@{@"kwDetailId":[NSString stringWithFormat:@"%ld",(long)self.pageId]}];
//    [MobClick event:@"reportpv"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadguangGao];
    [self loadData];
     _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    OBBottomBackView *backView = [[OBBottomBackView alloc]initWithFrame:CGRectMake(0, kScreenHeight - KViewHeight(70), kScreenWidth, KViewHeight(50))];
    [self.view addSubview:backView];
    self.backView = backView;
    backView.backbottomDelegate = self;
    backView.showChat = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.photoArrays = [NSMutableArray array];
    self.picUrlArray = [NSMutableArray array];
}

- (void)initViews
{
//    _hud.dimBackground = YES;
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view  addSubview:scrollerView];
    scrollerView.delegate = self;
     scrollerView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
//    scrollerView.bounces = NO;
    scrollerView.showsVerticalScrollIndicator = YES;
    self.scrollerView = scrollerView;
    
    //顶部背景图、tag
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kImageOriginHight, kScreenWidth,kScreenWidth)];
    topImage.contentMode = UIViewContentModeScaleAspectFill;
    topImage.clipsToBounds=YES;
    self.topImage = topImage;
    [scrollerView addSubview:topImage];
    
    UIImageView *maskView = [[UIImageView alloc]initWithFrame:topImage.bounds];
    [topImage addSubview:maskView];
    self.maskView = maskView;
    maskView.userInteractionEnabled = YES;
    //    maskView.backgroundColor = HWRandomColor;
    maskView.image = [UIImage imageNamed:@"u16"];
    
    //类型
    UILabel *greenLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10),0, KViewWidth(100), KViewHeight(4))];
    greenLabel.backgroundColor = HWColor(31, 167, 86);
    [topImage addSubview:greenLabel];

    UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), greenLabel.bottom, KViewWidth(100), KViewHeight(36))];
    categoryLabel.textColor = HWColor(255, 255, 255);
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    categoryLabel.font = [UIFont boldSystemFontOfSize:KFont(16.0)];
    categoryLabel.numberOfLines = 0;
    [topImage addSubview:categoryLabel];
    self.categoryLabel = categoryLabel;
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), self.topImage.height - KViewHeight(80), kScreenWidth - KViewWidth(20), KViewHeight(60))];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    [topImage addSubview:label];
    self.titleLabel = label;

}

- (void)loadData
{
    
    NSString *urlString = OBKPDetailUrl(self.pageId);
    [OBDataService requestWithURL:urlString params:nil httpMethod:@"GET" completionblock:^(id result) {
        NSNumber *code = result[@"ret_code"];
        [_hud hide:YES];
        if ([code integerValue] == 0) {
            [self praseDataWithResult:result];
        } else if ([code integerValue] == -1) {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            view.backgroundColor = [UIColor whiteColor];
            //                    view.backgroundColor = HWRandomColor;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(220))/2, (kScreenHeight - KViewWidth(280))/2, KViewWidth(220), KViewWidth(220))];
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:@"pagefailed_bg"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.left, imageView.bottom + KViewHeight(20), imageView.width, KViewHeight(60))];
            label.textColor = [UIColor grayColor];
            label.text = @"该文章已被撤销";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            [view addSubview:imageView];
            [self.view addSubview:view];
            [self.view addSubview:self.backView];
        }
        
    } failedBlock:^(id error) {
        [_hud hide:YES afterDelay:2];
        [MBProgressHUD showAlert:error];

    }];
    
}
- (void)loadguangGao
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@0 forKey:@"page"];
    [params setObject:@1 forKey:@"page_rows"];
    [params setObject:[NSNumber numberWithInteger:self.pageId] forKey:@"nid"];
    
    [OBDataService requestWithURL:OBGuangGaoUrl params:params httpMethod:@"GET" completionblock:^(id result) {
        [self praseGuanggaoWithResult:result];
        
    } failedBlock:^(id error) {
        
    }];
}
- (void)loadRelateds
{
   
    NSArray *pageids = self.detailModel.relateds;
    
    if (pageids.count > 0) {
        NSInteger y = arc4random() % pageids.count;
        NSNumber *pageNumber = pageids[y];
        NSInteger pageId = [pageNumber integerValue];
        NSString *urlString = OBKPDetailUrl(pageId);
        [OBDataService requestWithURL:urlString params:nil httpMethod:@"GET" completionblock:^(id result) {
            [self praseRelatedsDataWithResult:result];
            
        } failedBlock:^(id error) {
            
        }];
        
    }
    
}

- (void)praseDataWithResult:(id)result
{
//    [self initViews];
    OBKPDetailModel *listmodel = [OBKPDetailModel objectWithKeyValues:result];
    self.detailModel = listmodel;
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:listmodel.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
    self.categoryLabel.text = listmodel.category;
    self.titleLabel.text = listmodel.title;
    NSMutableAttributedString * attributedString2 =[NSString attributedStringWithText:self.titleLabel.text WithLineSpace:KViewHeight(7)];
    [self.titleLabel setAttributedText:attributedString2];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    self.backView.nid = listmodel.nid;
//    self.backView.ChatCount = listmodel.chat_count;
//    self.subtitleLabel.text = listmodel.subtitle;
    CGFloat xOffset = KViewWidth(10);
    CGFloat Leftedge = KViewWidth(130);
    CGFloat lasty = 0;
    NSInteger index = 0;
    //添加标签
    if (listmodel.tags.count > 0 ) {
        for (int i = 0; i < listmodel.tags.count; i++) {
            NSString *tagName = [listmodel.tags[i] objectForKey:@"name"];
            CGRect textSize = [tagName boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(13.0)]} context:nil];
            NSInteger width = xOffset;
            NSInteger y = (xOffset + textSize.size.width )/ (kScreenWidth - Leftedge) + index;
            NSInteger x = width % (int)(kScreenWidth - Leftedge);
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - x - textSize.size.width - KViewWidth(10) ,KViewHeight(5) + y * KViewHeight(35),textSize.size.width + KViewWidth(15), KViewHeight(30))];
            if (y != lasty) {
                index++;
                lasty = y;
                xOffset = 5;
                label.frame = CGRectMake(kScreenWidth - KViewWidth(20) - textSize.size.width, KViewHeight(5) + y * KViewHeight(35),textSize.size.width + KViewWidth(15), KViewHeight(30));
            }
            label.text = tagName;
            label.layer.cornerRadius = KViewWidth(15);
            label.layer.masksToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
//            label.backgroundColor = HWColor(225, 141, 98);
            label.font = [UIFont systemFontOfSize:KFont(13.0)];
            xOffset += textSize.size.width + KViewHeight(25);
            
            UIImageView *backImage = [[UIImageView alloc]init];
            UIImage *image = [UIImage imageNamed:@"tag_green"];
            image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:14];
            backImage.image = image;
            backImage.frame = label.frame;
            [self.topImage addSubview:backImage];
            [self.topImage addSubview:label];
        }
    }
    [self initContentViews];
    
}
- (void)praseGuanggaoWithResult:(id)result
{
    NSArray *array = result[@"data"];
    if (array.count > 0) {
        NSInteger y = arc4random() % array.count;
        NSDictionary *dic = array[y];
        OBGuangGaoModel *model = [OBGuangGaoModel objectWithKeyValues:dic];
        self.guangGaoModel = model;
       
       
    }
    
    
}
- (void)praseRelatedsDataWithResult:(id)result
{
     NSLog(@"相关文章");
//    NSDictionary *dic = result[@"result"];
    OBKPDetailModel *listmodel = [OBKPDetailModel objectWithKeyValues:result];
    OBKPListModel *kpListModel = [[OBKPListModel alloc]init];
    self.kpListModel = kpListModel;
    kpListModel.category = listmodel.category;
    kpListModel.title = listmodel.title;
    kpListModel.subtitle = listmodel.subtitle;
    kpListModel.summary = listmodel.summary;
    kpListModel.created_time = listmodel.created_time;
    kpListModel.nid = listmodel.nid;
    kpListModel.img_uri = listmodel.img_uri;
    kpListModel.comment_count = listmodel.comment_count;
    kpListModel.chat_count = listmodel.chat_count;
    
    OBKPRelatedCardView *view = [[OBKPRelatedCardView alloc]initWithFrame:CGRectMake(0, self.grayLabel.bottom, kScreenWidth, KViewHeight(460))];
    [self.scrollerView addSubview:view];
    view.listModel = kpListModel;
    view.relatedCardDelegate = self;
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, view.bottom - 49)];
    
}
- (void)initContentViews
{
    NSLog(@"初始化n内容布局");
    //优客出品
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.topImage.bottom, kScreenWidth , 1)];
    lineLabel.backgroundColor = HWColor(36, 159, 86);
    [self.scrollerView addSubview:lineLabel];
    UIImageView *greenback = [[UIImageView alloc]initWithFrame:CGRectMake(lineLabel.centerX - KViewWidth(60), lineLabel.top, KViewWidth(120),KViewHeight(50))];
    greenback.image = [UIImage imageNamed:@"ellipse"];
    [self.scrollerView addSubview:greenback];
    UILabel *greenLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.centerX - KViewWidth(50), lineLabel.top + KViewHeight(3), KViewWidth(100),KViewHeight(30))];
//    greenLabel.backgroundColor = [UIColor greenColor];
    greenLabel.text = self.detailModel.publisher;
    greenLabel.font = [UIFont systemFontOfSize:KFont(15.0)];
    CGSize timeSize = [greenLabel.text sizeWithFont:greenLabel.font];
    greenLabel.width = timeSize.width;
    greenback.width = timeSize.width + KViewWidth(30);
    greenLabel.centerX = kScreenWidth/2;
    greenback.centerX = kScreenWidth/2;
    greenLabel.textAlignment = NSTextAlignmentCenter;
    greenLabel.textColor = [UIColor whiteColor];
    [self.scrollerView addSubview:greenLabel];
    //副标
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), greenback.bottom + KViewHeight(20), kScreenWidth - KViewWidth(20), KViewHeight(80))];
    label.textColor =  HWColor(153, 153, 153);
//    label.backgroundColor = HWRandomColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:KFont(14.0)];
    label.text = self.detailModel.subtitle;
    NSMutableAttributedString * attributedString =[NSString attributedStringWithText:label.text WithLineSpace:KViewHeight(5)];
    [label setAttributedText:attributedString];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = label.font;
    attrs[NSKernAttributeName] =[NSNumber numberWithFloat:KViewHeight(5)];
    CGRect textSize = [label.text boundingRectWithSize:CGSizeMake(kScreenWidth - KViewWidth(10), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading  attributes:attrs context:nil];
    label.height = textSize.size.height + KViewHeight(10);
    [self.scrollerView addSubview:label];
    self.subtitleLabel = label;
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + label.height + KViewHeight(80))];
    
    UILabel *graylineLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), label.bottom + KViewHeight(15), kScreenWidth - KViewWidth(10), 0.5)];
    graylineLabel.backgroundColor = HWColor(240, 240, 240);
    [self.scrollerView addSubview:graylineLabel];
    
    //内容 Html
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, graylineLabel.bottom + KViewHeight(10), kScreenWidth, KViewHeight(50))];
    webView.delegate = self;
    webView.tag = 100;
//    webView.backgroundColor = HWRandomColor;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.scrollEnabled = NO;
    self.webView = webView;
    // 为webview添加点击手势
    [self addTapOnWebView];
    
    NSString *cssString = [NSString stringWithFormat:@"<html> <head> <meta charset=\"utf-8\"> <style type=\"text/css\"> body{text-align:justify;line-height: %fpx},td,th { color: #000;}img{ width:100%%; height:auto;text-align:left}p{ margin:0px; padding:0px;line-height:%fpx;} </style> </head> <body>",KFont(21.0),KFont(21.0)];
    if (self.detailModel.lead == nil) {
        self.detailModel.lead = @"";
    }
    NSString *xString = [cssString stringByAppendingString:self.detailModel.lead];
    NSString *endSting = @"</body> </html>";
    NSString *webString = [xString stringByAppendingString:endSting];
    [webView loadHTMLString:webString baseURL:nil];
    //获取webView 中的所有图片
    [self rePraseContentWithString:webString];
    [self.scrollerView addSubview:webView];
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + KViewHeight(25))];
        //
}
// 为webview添加点击手势
-(void)addTapOnWebView
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnWebView:)];
    [self.webView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}
// 为imagewebview添加点击手势
-(void)addTapOnimageWebView
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnimageWebView:)];
    [self.imagewebView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}
- (void)initAfterLoadLeadWebView
{
    NSLog(@"内容加载完成布局");
     NSLog(@"开始加载图片webView");
    //优客评级
    UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5),self.webView.bottom + KViewHeight(20) , kScreenWidth - KViewWidth(10), 0.5)];
    lineLabel1.backgroundColor = HWColor(36, 159, 86);
    [self.scrollerView addSubview:lineLabel1];
    UIImageView *greenback = [[UIImageView alloc]initWithFrame:CGRectMake(lineLabel1.centerX - KViewWidth(60), lineLabel1.top, KViewWidth(120),KViewHeight(50))];
    greenback.image = [UIImage imageNamed:@"ellipse"];
    [self.scrollerView addSubview:greenback];
    UILabel *greenLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel1.centerX - KViewWidth(50), lineLabel1.top, KViewWidth(100),KViewHeight(30))];
//    greenLabel1.backgroundColor = [UIColor greenColor];
    greenLabel1.text = @"优恪评级";
    greenLabel1.font = [UIFont systemFontOfSize:KFont(15.0)];
    greenLabel1.textAlignment = NSTextAlignmentCenter;
    greenLabel1.textColor = [UIColor whiteColor];
    [self.scrollerView addSubview:greenLabel1];
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + KViewHeight(70))];
    NSString *xString = @"";
    NSString *bodyImageString;
    for (int i = 0; i < self.detailModel.grade_mb_pic_img_uri.count; i ++) {
        NSString *imageString = self.detailModel.grade_mb_pic_img_uri[i];
        if (imageString == nil) {
            imageString = @"";
        }
        if (bodyImageString.length > 0) {
            bodyImageString = [NSString stringWithFormat:@"%@<img src=\"""%@\"""/>",bodyImageString,imageString];
        } else
            bodyImageString = [NSString stringWithFormat:@"<img src=\"""%@\"""/>",imageString];
       
    }
//    NSString *bodyImageString = [NSString stringWithFormat:@"<img src='""%@""'/>",imageString];
   NSString *cssString = [NSString stringWithFormat:@"<html> <head> <meta charset=\"utf-8\"> <style type=\"text/css\"> body{text-align:justify; font-size: %fpx; line-height: %fpx},td,th { color: #000;}img{ width:100%%; height:auto;text-align:left} </style> </head> <body>",KFont(16.0),KFont(21.0)];
    
    xString = [cssString stringByAppendingString:bodyImageString];
    NSString *endSting = @"</body> </html>";
    NSString *webString = [xString stringByAppendingString:endSting];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(KViewWidth(5), greenback.bottom + KViewHeight(10), kScreenWidth - KViewWidth(10), KViewHeight(50))];
    webView.delegate = self;
    webView.tag = 101;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.scrollEnabled = NO;
    [webView loadHTMLString:webString baseURL:nil];
    self.imagewebView = webView;
    // 为imagewebView添加点击手势
    [self addTapOnimageWebView];
    
    [self rePraseContentWithString:webString];
    [self.scrollerView addSubview:webView];

}
- (void)initAfterLoadWebView
{
     NSLog(@"优客评级说明");
           //优客评级说明
    UILabel *gradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), self.imagewebView.bottom + KViewHeight(10), KViewWidth(200),KViewHeight(20))];
    gradeLabel.text = @"优恪评级说明";
    gradeLabel.textAlignment = NSTextAlignmentLeft;
    gradeLabel.textColor = [UIColor blackColor];
    gradeLabel.font = [UIFont boldSystemFontOfSize:KFont(16.0)];
    [self.scrollerView addSubview:gradeLabel];
    UILabel *graylineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), gradeLabel.bottom + KViewHeight(15), kScreenWidth - KViewWidth(10), 0.5)];
    graylineLabel2.backgroundColor = HWColor(240, 240, 240);
    [self.scrollerView addSubview:graylineLabel2];
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + KViewHeight(30))];
    UILabel *gradeContentlabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(5), graylineLabel2.bottom + KViewHeight(10), kScreenWidth - KViewWidth(10), KViewHeight(60))];
    gradeContentlabel.textColor = HWColor(110, 102, 102);
    gradeContentlabel.textAlignment = NSTextAlignmentLeft;
    gradeContentlabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    gradeContentlabel.text = @"从最好的“卓越（A+）”到最差的“警示（D-）”，优恪将产品分为6个等级。一方面，产品缺陷的数量决定评级：缺陷越多，评级越低；另一方面，缺陷的严重性也影响评级。一款产品如果违反法律法规并危害消费者健康，而不应在市场上销售，将会被直接评为“警示（D-）”。\n作为优质生活的恪守者，优恪不仅以“符合国标”来审视产品，而是对产品质量提出更高要求。因此，优恪的评分标准是由德国专家团队参考中国、欧盟、世卫组织的标准以及国际最新科研成果制定，可能高于中国以及欧盟标准。2015至2016年度，优恪将集中测评在中国市场销售的国际、港澳台品牌及进口产品。";
    gradeContentlabel.numberOfLines = 0;
    NSMutableAttributedString * attributedString =[NSString attributedStringWithText:gradeContentlabel.text WithLineSpace:KViewHeight(5)];
    [gradeContentlabel setAttributedText:attributedString];
//    gradeContentlabel.backgroundColor = HWRandomColor;
    gradeContentlabel.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = gradeContentlabel.font;
    attrs[NSKernAttributeName] =[NSNumber numberWithFloat:KViewHeight(5)];
    CGRect gradeContentSize = [gradeContentlabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - KViewWidth(10), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil];
    gradeContentlabel.height = gradeContentSize.size.height + KViewHeight(10);
    [self.scrollerView addSubview:gradeContentlabel];
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + gradeContentlabel.height + KViewHeight(20))];
    
    
   UIImageView *guangGaoImage;
    if (self.guangGaoModel) {
        //推广
        UILabel *idlineLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10),gradeContentlabel.bottom + KViewHeight(30), kScreenWidth - KViewWidth(20), 0.5)];
        idlineLabel.backgroundColor = HWColor(240, 240, 240);
        [self.scrollerView addSubview:idlineLabel];
        UILabel *idlabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(50), idlineLabel.top - KViewHeight(10), KViewWidth(40), KViewHeight(20))];
        idlabel.text = @"推广";
        idlabel.font = [UIFont systemFontOfSize:KFont(14.0)];
        idlabel.textColor = HWColor(153, 153, 153);
        idlabel.textAlignment = NSTextAlignmentCenter;
        idlabel.backgroundColor = [UIColor whiteColor];
        [self.scrollerView addSubview:idlabel];
        
        guangGaoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, idlineLabel.bottom + KViewHeight(25), kScreenWidth, KViewHeight(180))];
        [guangGaoImage sd_setImageWithURL:[NSURL URLWithString:self.guangGaoModel.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
        [self.scrollerView addSubview:guangGaoImage];
        [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + KViewHeight(235))];
        NSLog(@"广告");
    }
    CGFloat height = guangGaoImage.bottom;
    if (self.guangGaoModel == nil) {
        height = gradeContentlabel.bottom + KViewHeight(10);
    }
    UILabel *grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,height, kScreenWidth, KViewHeight(20))];
    grayLabel.backgroundColor = HWColor(240, 240, 240);
    [self.scrollerView addSubview:grayLabel];
    //详细数据  检测数据
    UIView *reportView = [self createSingleViewWithViewFrame:CGRectMake(0,grayLabel.bottom , kScreenWidth, KViewHeight(50)) ViewName:@"详细报告"];
    NSLog(@"reportView%@",[reportView description]);
    reportView.tag = 100;
    [self.scrollerView addSubview:reportView];
    UIView *jianceView = [self createSingleViewWithViewFrame:CGRectMake(0,reportView.bottom, kScreenWidth, KViewHeight(50)) ViewName:@"检测数据"];
    jianceView.tag = 101;
    [self.scrollerView addSubview:jianceView];
    UILabel *grayLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, jianceView.bottom, kScreenWidth, KViewHeight(20))];
    grayLabel2.backgroundColor = HWColor(240, 240, 240);
    self.grayLabel = grayLabel2;
    [self.scrollerView addSubview:grayLabel2];
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + KViewHeight(140))];
    OBLog(@"检测数据。。。。。。。。。");

}
//只包括一行的视图
- (UIView *)createSingleViewWithViewFrame:(CGRect)frame ViewName:(NSString *)name
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(10), KViewWidth(100), KViewHeight(30))];
    titleLabel.text = name;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [view addSubview:titleLabel];
    
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(view.right - KViewWidth(50) , view.height/2 - KViewHeight(16) , KViewWidth(30), KViewHeight(30))];
    arrowImage.image = [UIImage imageNamed:@"u33.png"];
    [view addSubview:arrowImage];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.height - 1, kScreenWidth, 1)];
    line.image = [UIImage imageNamed:@"u19_line"];
    line.backgroundColor = HWColor(242, 242, 242);
    [view addSubview:line];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:tap];
    return view;
}


//- (void)backButton
//{
//    if (self.navigationController.viewControllers.count > 1) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else {
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height)));
    if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height)< KViewHeight(100) && isfinishLoadWeb == YES ) {
        //加载相关文章
        if (!isFirst) {
            isFirst = YES;
            [self loadRelateds];
        }
        
    }
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > KViewHeight(25)) {
        _lastPosition = currentPostion;
//        NSLog(@"ScrollUp now");
        self.backView.alpha = 0;
    }
    else if (_lastPosition - currentPostion > KViewHeight(25))
    {
        _lastPosition = currentPostion;
//        NSLog(@"ScrollDown now");
        self.backView.alpha = 1;
    }

    if (currentPostion < -kImageOriginHight) {
        CGRect f = self.topImage.frame;
        f.origin.y = currentPostion;
        f.size.height =  -currentPostion;
        self.topImage.frame = f;
        self.maskView.frame = self.topImage.bounds;
        self.titleLabel.top = self.topImage.height - KViewHeight(80);
    }
}
#pragma mark - TapActions
-(void)singleTapOnWebView:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.webView];
    [self tapwithPoint:pt withWebView:self.webView];
    
}

-(void)singleTapOnimageWebView:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.imagewebView];
    [self tapwithPoint:pt withWebView:self.imagewebView];
}

- (void)tapwithPoint:(CGPoint)point withWebView:(UIWebView *)webView
{
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
    NSString *urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
    NSString *suburl = nil;
    if (urlToSave.length > 0) {
        suburl = [urlToSave substringFromIndex:26];
    }
    OBLog(@"%@",urlToSave);
    if (![urlToSave isEqualToString:@""]) {
        OBPhotoBrowser *brower = [[OBPhotoBrowser alloc]init];
        NSInteger index = 0;
        if ([self.picUrlArray containsObject:urlToSave]) {
            index = [self.picUrlArray indexOfObject:urlToSave];
        } else
        {
            for (int i = 0; i< self.picUrlArray.count; i ++) {
                NSString *string = self.picUrlArray[i];
                if ([string rangeOfString:suburl].location != NSNotFound) {
                    index = i;
                }
            }
        }
        brower.currentPhotoIndex = index;
        brower.photos = self.photoArrays;
        [brower show];
    }

}
- (void)rePraseContentWithString:(NSString *)string
{
    NSMutableArray *picArray = [NSMutableArray array];
    NSError *error;
//    OBLog(@"string = %@",string);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"http(s)?://[a-zA-Z0-9_\\.@%&/\?=:-]*.(jpg|png)" options:0 error:&error];
    if (regex != nil) {
        
        NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            if (NSNotFound != matchRange.location) {
                NSString *picUrl = [string substringWithRange:matchRange];
                [picArray addObject:picUrl];
            }
            
        }
        [self.picUrlArray addObjectsFromArray:picArray];
    }
    if (picArray.count > 0) {
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:picArray.count];
        for (int i =0; i< picArray.count; i++) {
            OBPhoto *photo = [[OBPhoto alloc]init];
            photo.urlString = picArray[i];
            [photos addObject:photo];
        }
//        return photos;
        [self.photoArrays addObjectsFromArray:photos];
    }
//    else
//        return nil;
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - OBKWRelatedCardDelegate
- (void)didTapRelatedView
{
    OBKPDetailViewController *kwd = [[OBKPDetailViewController alloc]init];
    kwd.pageId = self.kpListModel.nid;
    [self.navigationController pushViewController:kwd animated:YES];
//    [self presentViewController:kwd animated:NO completion:nil];
}
- (void)didSelectedKPRelatedChatButtonWithListModel:(OBKPListModel *)listModel
{
    OBChatRoomController *chatVC = [[OBChatRoomController alloc]init];
    chatVC.chatId = listModel.nid;
    chatVC.roomtitle = listModel.title;
    [self.navigationController pushViewController:chatVC animated:YES];
//    [self presentViewController:chatVC animated:YES completion:nil];
}
- (void)didSelectedKPRelatedCommentButtonWithListModel:(OBKPListModel *)listModel
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = listModel.nid;
    commentVC.commentTitle = listModel.title;
    [self.navigationController pushViewController:commentVC animated:YES];
//    [self presentViewController:commentVC animated:YES completion:nil];
}
- (void)didSelectedKPRelatedMoreButtonWithListModel:(OBKPListModel *)listModel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    OBVisualEffectView *effview  = [[OBVisualEffectView alloc]initWithFrame:lastWindow.frame];
    self.eff = effview;
    effview.isKePing = YES;
    effview.nid = listModel.nid;
    effview.visualDelegate = self;
    [lastWindow addSubview:effview];
}


#pragma mark - OBBottomBackViewDelegate
- (void)backViewdidSelectedBackbutton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)backViewdidSelectedCommentButton
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = self.detailModel.nid;
    commentVC.commentTitle = self.detailModel.title;
    [self.navigationController pushViewController:commentVC animated:YES];
//    [self presentViewController:commentVC animated:YES completion:nil];
}
- (void)backViewdidSelectedChatButton
{
    OBChatRoomController *chatRoom = [[OBChatRoomController alloc]init];
    chatRoom.chatId = self.detailModel.nid;
    chatRoom.roomtitle = self.detailModel.title;
    [self.navigationController pushViewController:chatRoom animated:YES];
//    [self presentViewController:chatRoom animated:YES completion:nil];
}
- (void)backViewdidSelectedShareButton
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    OBVisualEffectView *effview  = [[OBVisualEffectView alloc]initWithFrame:lastWindow.frame];
    effview.visualDelegate = self;
    self.eff = effview;
    effview.isKePing = YES;
    effview.nid = self.detailModel.nid;
//    effview.likeCount = self.detailModel.like_count;
//    effview.commentCount = self.detailModel.comment_count;
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
        
        [params setObject:[NSString stringWithFormat:@"%ld",self.detailModel.nid ]forKey:@"nid"];
        
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
                NSNumber *code = result[@"ret_code"];
                if ([code integerValue] == - 9) {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"取消收藏"];
//                    self.eff.likeCount =self.detailModel.like_count;
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
        [self.navigationController pushViewController:OKOerVC animated:YES];
//        [self presentViewController:OKOerVC animated:YES completion:nil];
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
        
        [params setObject:[NSString stringWithFormat:@"%ld",self.detailModel.nid ]forKey:@"nid"];
        
        if (isSelected) {
            //点赞
            [OBDataService requestWithURL:OBLIKEURL(uid, timeString, sign) params:params httpMethod:@"POST" completionblock:^(id result) {
                NSNumber *code = result[@"ret_code"];
                if ([code integerValue] == - 9) {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"点赞成功"];
//                    NSInteger lastCount = self.detailModel.like_count;
//                    NSInteger currentCount = lastCount + 1;
//                    self.eff.likeCount = currentCount;
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
//                    [KLToast showToast:@"取消点赞"];
//                    self.eff.likeCount =self.detailModel.like_count;
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
        }
        
    } else {
        OBOKOerLoginViewController *OKOerVC = [[OBOKOerLoginViewController alloc]init];
        [self.navigationController pushViewController:OKOerVC animated:YES];
//        [self presentViewController:OKOerVC animated:YES completion:nil];
    }
    
}

- (void)didSelectedCommentButton
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = self.detailModel.nid;
    commentVC.commentTitle = self.detailModel.title;
    [self.navigationController pushViewController:commentVC animated:YES];
//    [self presentViewController:commentVC animated:YES completion:nil];
}
/**
 *
 *
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
    urlString = self.detailModel.web_path;
    imageString = self.detailModel.img_uri;
    content = self.detailModel.summary;
    title = self.detailModel.title;
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

#pragma  mark - webViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_hud hide:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.tag == 100) {
        //内容webView
        CGRect frame = webView.frame;
        frame.size.width = self.scrollerView.width;
        frame.size.height = 1;
        webView.frame = frame;
        frame.size.height = webView.scrollView.contentSize.height;
        webView.frame = frame;
        [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, webView.frame.size.height + self.scrollerView.contentSize.height)];
         NSLog(@"contentWebView ------------");
        //优客评级
        [self initAfterLoadLeadWebView];
       
//         [_hud hide:YES];
    } else if (webView.tag == 101) {
        //忧恪评级webView
        CGRect frame = webView.frame;
        frame.size.width = self.scrollerView.width;
        frame.size.height = 1;
        webView.frame = frame;
        frame.size.height = webView.scrollView.contentSize.height;
        webView.frame = frame;
        [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, webView.frame.size.height + self.scrollerView.contentSize.height)];
        NSLog(@"picWebView ------------");
        //推广
        [self initAfterLoadWebView];
        
        isfinishLoadWeb = YES;
         [_hud hide:YES];
    }
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    } else
        return YES;
}
- (void)tapGesture:(UITapGestureRecognizer *)reg
{
    OBDetailReportViewController *detailVC = [[OBDetailReportViewController alloc]init];
    if (reg.view.tag == 100) {
        //详细报告
        detailVC.selectedPage = 0;
        
    } else if (reg.view.tag == 101) {
        //检测数据
         detailVC.selectedPage = 1;        
    }
    detailVC.jianCeDatas = self.detailModel.sheet_imgs;
    detailVC.reportString = self.detailModel.report_lead;
    [self.navigationController pushViewController:detailVC animated:YES];
//    [self presentViewController:detailVC animated:YES completion:nil];

}

-(void)didReceiveMemoryWarning
{
    NSLog(@"OBKPDetailViewController--didReceiveMemoryWarning");
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
