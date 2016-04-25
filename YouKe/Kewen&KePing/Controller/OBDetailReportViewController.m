//
//  OBDetailReportViewController.m
//  YouKe
//
//  Created by obally on 15/8/21.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBDetailReportViewController.h"
#import "OBSingleColorView.h"
#import "OBPhotoBrowser.h"
#import "OBPhoto.h"
@interface OBDetailReportViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) UIScrollView *rootScrollView;
@property (nonatomic, retain) UIScrollView *scroll1;
@property (nonatomic, retain) UIScrollView *scroll2;
@property(nonatomic,assign)NSInteger currentpageid;
@property (nonatomic, retain) UIWebView *reportWebView;
@property (nonatomic, retain) UIWebView *dataWebView;
@property (nonatomic,retain)NSMutableArray *picUrlArray; //所有图片
@property (nonatomic,retain)NSMutableArray *photoArrays; //OBPhoto对象
@end

@implementation OBDetailReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoArrays = [NSMutableArray array];
    self.picUrlArray = [NSMutableArray array];
    [self initViews];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    self.currentpageid = 0;
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
   UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(20), KViewWidth(24), KViewWidth(24))];
    [backButton setBackgroundImage:[UIImage imageNamed:@"u215"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:backButton];
    
    //详细报告
    UIButton *reportButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(160) - KViewWidth(50))/2, KViewHeight(10), KViewWidth(80), KViewHeight(40))];
    reportButton.tag = 300;
    if (self.selectedPage == 0) {
        [reportButton setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
    }
    else
       [reportButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
    
    [reportButton setTitle:@"详细报告" forState:UIControlStateNormal];
    
    [reportButton addTarget:self action:@selector(reportButton:) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:reportButton];
    //检测数据
    UIButton *jianceButton = [[UIButton alloc]initWithFrame:CGRectMake(reportButton.right + KViewWidth(50), KViewHeight(10), KViewWidth(80), KViewHeight(40))];
    jianceButton.tag = 301;
    [jianceButton setTitle:@"检测数据" forState:UIControlStateNormal];
    [jianceButton addTarget:self action:@selector(jianceButton:) forControlEvents:UIControlEventTouchUpInside];
    if (self.selectedPage == 1) {
        [jianceButton setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
    }
    else
        [jianceButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
    
    [visualEffect addSubview:jianceButton];
    
    UIScrollView *rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KViewHeight(60), kScreenWidth, kScreenHeight)];
    rootScrollView.delegate = self;
//    rootScrollView.pagingEnabled = YES;
    rootScrollView.bounces = NO;
    self.rootScrollView = rootScrollView;
    rootScrollView.showsVerticalScrollIndicator = NO;
    rootScrollView.showsHorizontalScrollIndicator = NO;
    rootScrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    //详细报告
    UIScrollView *scroll1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scroll1.bounces = NO;
//    scroll1.backgroundColor = HWRandomColor;
//    scroll1.scrollEnabled = NO;
    scroll1.showsVerticalScrollIndicator = NO;
    scroll1.showsHorizontalScrollIndicator = NO;
    self.scroll1 = scroll1;
    [rootScrollView addSubview:scroll1];
    if (self.reportString.length == 0) {
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, rootScrollView.height)];
        [scroll1 addSubview:view2];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(50), KViewWidth(200), KViewHeight(50))];
        label.text = @"暂无详细报告";
        label.textAlignment = NSTextAlignmentCenter;
        [view2 addSubview:label];
    } else
    {
        UIWebView *webView1 = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, rootScrollView.height)];
        webView1.scrollView.showsHorizontalScrollIndicator = NO;
        webView1.scrollView.showsVerticalScrollIndicator = NO;
        webView1.scrollView.scrollEnabled = NO;
        webView1.tag = 100;
        webView1.delegate = self;
       NSString *cssString = [NSString stringWithFormat:@"<html> <head> <meta charset=\"utf-8\"> <style type=\"text/css\"> body{text-align:justify; font-size: %fpx; line-height: %fpx},td,th { color: #000;}img{ width:100%%; height:auto;text-align:left}p{ margin:0px; padding:0px;line-height:%fpx;}span{ font-size: %fpx;} </style> </head> <body>",KFont(15.0),KFont(21.0),KFont(21.0),KFont(15.0)];
        NSString *xString = [cssString stringByAppendingString:self.reportString];
        NSString *endSting = @"</body> </html>";
        NSString *webString = [xString stringByAppendingString:endSting];
        [webView1 loadHTMLString:webString baseURL:nil];
        [scroll1 addSubview:webView1];
        self.reportWebView = webView1;
        // 为imagewebView添加点击手势
        [self addTapOnReportWebView];
        
        [self rePraseContentWithString:webString];
       
    }
    //检测数据
    UIScrollView *scroll2 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    //    scroll2.backgroundColor = HWRandomColor;
    scroll2.showsHorizontalScrollIndicator = NO;
    scroll2.showsVerticalScrollIndicator = NO;
    scroll2.bounces = NO;
    self.scroll2 = scroll2;
    [rootScrollView addSubview:scroll2];
    if (self.jianCeDatas.count == 0) {
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, rootScrollView.height)];
        [scroll2 addSubview:view2];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(200))/2, KViewHeight(50), KViewWidth(200), KViewHeight(50))];
        label.text = @"暂无检测数据";
        label.textAlignment = NSTextAlignmentCenter;
        [view2 addSubview:label];
        
    } else {
        UIWebView *webView2 = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, rootScrollView.height)];
        webView2.scrollView.showsHorizontalScrollIndicator = NO;
        webView2.scrollView.showsVerticalScrollIndicator = NO;
        webView2.scrollView.scrollEnabled = NO;
        webView2.tag = 102;
        webView2.delegate = self;
        [scroll2 addSubview:webView2];
        NSString *xString2 = @"";
        NSString *bodyImageString;
        for (int i = 0; i < self.jianCeDatas.count; i ++) {
            NSString *imageString = self.jianCeDatas[i];
            if (imageString == nil) {
                imageString = @"";
            }
            if (bodyImageString.length > 0) {
                bodyImageString = [NSString stringWithFormat:@"%@<img src='""%@""'/>",bodyImageString,imageString];
            } else
                bodyImageString = [NSString stringWithFormat:@"<img src='""%@""'/>",imageString];
            
            NSString *cssString = @"<html> <head> <meta charset=\"utf-8\"> <style type=\"text/css\"> body,td,th { color: #000;}img{ width:100%; height:auto;text-align:left} </style> </head> <body>";
            
            xString2 = [cssString stringByAppendingString:bodyImageString];
        }
        NSString *endSting2 = @"</body> </html>";
        NSString *webString2 = [xString2 stringByAppendingString:endSting2];
        [webView2 loadHTMLString:webString2 baseURL:nil];
        self.dataWebView = webView2;
        // 为imagewebView添加点击手势
        [self addTapOnDataWebView];
        //获取图片
        [self rePraseContentWithString:webString2];
    }
   
    self.rootScrollView = rootScrollView;
    [self.view addSubview:rootScrollView];
    if (self.selectedPage == 1) {
         [self.rootScrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
    }
    
}
// 为ReportWebView添加点击手势
-(void)addTapOnReportWebView
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnReportWebView:)];
    [self.reportWebView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}
// 为dataWebView添加点击手势
-(void)addTapOnDataWebView
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnDataWebView:)];
    [self.dataWebView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}
-(void)singleTapOnReportWebView:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.reportWebView];
    [self tapwithPoint:pt withWebView:self.reportWebView];
    
}

-(void)singleTapOnDataWebView:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.dataWebView];
    [self tapwithPoint:pt withWebView:self.dataWebView];
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
    OBLog(@"string = %@",string);
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
        [self.photoArrays addObjectsFromArray:photos];
    }
    
    
}

#pragma mark - buttonAction
- (void)reportButton:(UIButton *)button
{
    NSInteger tag = button.tag - 300;
    [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
    if (tag != self.currentpageid) {
    
        UIButton *lastButton = (UIButton *)[self.effectView viewWithTag:self.currentpageid + 300];
        lastButton.selected = NO;
        [lastButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
        self.selectedPage = 0;
    }
}
- (void)jianceButton:(UIButton *)button
{
    NSInteger tag = button.tag - 300;
    [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
    if (tag != self.currentpageid) {
        UIButton *lastButton = (UIButton *)[self.effectView viewWithTag:self.currentpageid + 300];
        lastButton.selected = NO;
        [lastButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
        self.selectedPage = 1;
    }
}
- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSelectedPage:(NSInteger)selectedPage
{
    if (_selectedPage != selectedPage) {
        _selectedPage = selectedPage;
    }
    if (_selectedPage != self.currentpageid) {
        self.currentpageid = _selectedPage;
        [self.rootScrollView setContentOffset:CGPointMake(kScreenWidth * _selectedPage, 0)];
//        [self.rootScrollView scrollRectToVisible:CGRectMake(kScreenWidth * _selectedPage, 0, kScreenWidth, self.rootScrollView.height) animated:NO];
        
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   NSInteger tag = (NSInteger)(scrollView.contentOffset.x / kScreenWidth + 0.5);
    if (tag == 0 && tag != self.currentpageid) {
       UIButton *button =  (UIButton *)[self.effectView viewWithTag:tag + 300];
        [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
        UIButton *lastButton = (UIButton *)[self.effectView viewWithTag:self.currentpageid + 300];
        lastButton.selected = NO;
        [lastButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
        self.currentpageid = tag;
        
    } else if (tag == 1 && tag != self.currentpageid) {
        UIButton *button =  (UIButton *)[self.effectView viewWithTag:tag + 300];
        [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
        UIButton *lastButton = (UIButton *)[self.effectView viewWithTag:self.currentpageid + 300];
        lastButton.selected = NO;
        [lastButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
        self.currentpageid = tag;
    }
}
#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.tag == 100) {
                //优客评级
        CGRect frame = webView.frame;
        frame.size.width = self.rootScrollView.width;
        frame.size.height = 1;
        webView.frame = frame;
        frame.size.height = webView.scrollView.contentSize.height;
        webView.frame = frame;
        [self.scroll1 setContentSize:CGSizeMake(self.rootScrollView.width , webView.frame.size.height  + KViewHeight(80))];
        
    } else if (webView.tag == 102) {
        //忧恪评级webView
        CGRect frame = webView.frame;
        frame.size.width = self.rootScrollView.width;
        frame.size.height = 1;
        webView.frame = frame;
        frame.size.height = webView.scrollView.contentSize.height;
        webView.frame = frame;
        [self.scroll2 setContentSize:CGSizeMake(self.rootScrollView.width , webView.frame.size.height + KViewHeight(80))];

    }
    
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    NSLog(@"OBDetailReportControllerdidReceiveMemoryWarning");
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
