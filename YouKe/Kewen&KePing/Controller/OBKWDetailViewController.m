//
//  OBKWDetailViewController.m
//  YouKe
//
//  Created by obally on 15/8/5.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBKWDetailViewController.h"
#import "OBKWDetailModel.h"
#import "OBKWRelatedCardView.h"
#import "OBKWListModel.h"
#import "OBGuangGaoModel.h"
#import "UIImageView+WebCache.h"
#import "OBBottomBackView.h"
#import "OBVisualEffectView.h"
#import "NSString+Hash.h"
#import "OBOKOerLoginViewController.h"
#import "OBCommentViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "RegexKitLite.h"
#import "OBPhotoBrowser.h"
#import "OBPhoto.h"

#define kImageOriginHight KViewHeight(220)
@interface OBKWDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,OBKWRelatedCardViewDelegate,OBBottomBackViewDelegate,OBVisualEffectViewDelegate,UIGestureRecognizerDelegate>
{
    MBProgressHUD *_hud;
    BOOL isFirst;
    BOOL isFinishWebView;
    NSInteger _lastPosition;
}
@property (nonatomic, retain) UILabel *categoryLabel;
@property (nonatomic, retain) UIImageView *topImage;
@property (nonatomic, retain) UIImageView *maskView;
@property (nonatomic, retain) UIImageView *guanggaoImage;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, retain) UILabel *authorLabel;
@property (nonatomic, retain) UILabel *lineLabel;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIScrollView *scrollerView;
@property (nonatomic, retain) OBKWDetailModel *detailModel;
@property (nonatomic, retain) OBGuangGaoModel *guangGaoModel;
@property (nonatomic, retain) OBKWListModel *kwListModel;
@property (nonatomic, retain) OBBottomBackView *backView;
@property(nonatomic,copy)NSString *currentTimeOffset;
@property (nonatomic, retain) OBVisualEffectView *eff;
@property (nonatomic,retain)NSMutableArray *picUrlArray; //所有图片
@property (nonatomic,retain)NSMutableArray *photoArrays; //OBPhoto对象
@end

@implementation OBKWDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [MobClick event:@"newspv" attributes:@{@"kwDetailId":[NSString stringWithFormat:@"%ld",(long)self.pageId]}];
//    [MobClick event:@"newspv"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self loadData];
     _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    OBBottomBackView *backView = [[OBBottomBackView alloc]initWithFrame:CGRectMake(0, kScreenHeight - KViewHeight(70), kScreenWidth, KViewHeight(50))];
    [self.view addSubview:backView];
    backView.backbottomDelegate = self;
    backView.showChat = NO;
//    backView
    self.backView = backView;
    self.view.backgroundColor = [UIColor whiteColor];
   
}

- (void)initViews
{
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view  addSubview:scrollerView];
//    scrollerView.contentSize = CGSizeMake(kScreenWidth, KViewHeight(220));
    scrollerView.delegate = self;
    scrollerView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
//    scrollerView.backgroundColor = HWRandomColor;
//    scrollerView.bounces = NO;
    scrollerView.showsVerticalScrollIndicator = YES;
    self.scrollerView = scrollerView;

    //顶部背景图、tag
//    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(220))];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kImageOriginHight, kScreenWidth, kImageOriginHight)];
    topImage.contentMode = UIViewContentModeScaleAspectFill;
    topImage.clipsToBounds=YES;
    self.topImage = topImage;
    [scrollerView addSubview:topImage];
    
    UIImageView *maskView = [[UIImageView alloc]initWithFrame:topImage.bounds];
    [topImage addSubview:maskView];
    self.maskView = maskView;
    maskView.userInteractionEnabled = YES;
    maskView.image = [UIImage imageNamed:@"u16"];
    
    //类型
    UILabel *greenLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10),0, KViewWidth(100), KViewHeight(4))];
    greenLabel.backgroundColor = HWColor(255, 153, 102);
    [topImage addSubview:greenLabel];
   
    UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), greenLabel.bottom, KViewWidth(100), KViewHeight(36))];
    categoryLabel.textColor = HWColor(255, 255, 255);
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    categoryLabel.font = [UIFont boldSystemFontOfSize:KFont(16.0)];
    categoryLabel.numberOfLines = 0;
    [topImage addSubview:categoryLabel];
    self.categoryLabel = categoryLabel;
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), topImage.bottom + KViewHeight(10), kScreenWidth - KViewWidth(20), KViewHeight(60))];
    label.textColor = HWColor(51, 51, 51);
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
//    label.backgroundColor = HWRandomColor;
    label.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    [scrollerView addSubview:label];
    self.titleLabel = label;
    
    //附标题
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), label.bottom, kScreenWidth - KViewWidth(20), KViewHeight(45))];
    subLabel.textColor = HWColor(169, 169, 169);
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    subLabel.numberOfLines = 0;
//    subLabel.backgroundColor = HWRandomColor;
    [scrollerView addSubview:subLabel];
    self.subtitleLabel = subLabel;
    
    UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), subLabel.bottom + KViewHeight(10), kScreenWidth - KViewWidth(20), KViewHeight(20))];
    authorLabel.textColor = HWColor(169, 169, 169);
    authorLabel.textAlignment = NSTextAlignmentLeft;
    authorLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
    [scrollerView addSubview:authorLabel];
    self.authorLabel = authorLabel;
    
    //分割线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), authorLabel.bottom + KViewHeight(20), kScreenWidth - KViewWidth(20), 0.5)];
    lineLabel.backgroundColor = HWColor(240, 240, 240);
    self.lineLabel = lineLabel;
    [scrollerView addSubview:lineLabel];
    
    //内容 Html
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, lineLabel.bottom + KViewHeight(5), scrollerView.width, scrollerView.height -  lineLabel.bottom)];
    webView.delegate = self;
//    webView.backgroundColor = HWRandomColor;
    webView.backgroundColor = [UIColor clearColor];  //但是这个属性必须用代码设置，光 xib 设置不行
    webView.opaque = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.scrollEnabled = NO;
    webView.dataDetectorTypes = UIDataDetectorTypeAll;
    webView.userInteractionEnabled = YES;
    [scrollerView addSubview:webView];
    self.webView = webView;
    // 为webview添加点击手势
    [self addTapOnWebView];
}

// 为webview添加点击手势
-(void)addTapOnWebView
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.webView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

- (void)loadData
{
    
    NSString *urlString = OBKWDetailUrl(self.pageId);
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
        [KLToast showToast:error];
    }];
    
}
- (void)guangGao
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
        NSString *urlString = OBKWDetailUrl(pageId);
        [OBDataService requestWithURL:urlString params:nil httpMethod:@"GET" completionblock:^(id result) {
            [self praseRelatedsDataWithResult:result];
            
        } failedBlock:^(id error) {
            
        }];
        
    }
    
}
- (void)praseGuanggaoWithResult:(id)result
{
    NSArray *array = result[@"data"];
    if (array.count > 0) {
        NSInteger y = arc4random() % array.count;
        NSDictionary *dic = array[y];
        OBGuangGaoModel *model = [OBGuangGaoModel objectWithKeyValues:dic];
        self.guangGaoModel = model;
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), self.webView.bottom + KViewHeight(20), kScreenWidth - KViewWidth(20), 0.5)];
        lineLabel.backgroundColor = HWColor(204, 204, 204);
        [self.scrollerView addSubview:lineLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(50), lineLabel.top - KViewHeight(10), KViewWidth(40), KViewHeight(20))];
        label.text = @"推广";
        label.font = [UIFont systemFontOfSize:KFont(14.0)];
        label.textColor = HWColor(153, 153, 153);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [self.scrollerView addSubview:label];
        
        UIImageView *guangGaoImage = [[UIImageView alloc]initWithFrame:CGRectMake(KViewWidth(5), lineLabel.bottom + KViewHeight(25), kScreenWidth - KViewWidth(10), KViewHeight(180))];
        self.guanggaoImage = guangGaoImage;
        [guangGaoImage sd_setImageWithURL:[NSURL URLWithString:model.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
        [self.scrollerView addSubview:guangGaoImage];
        
        [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + KViewHeight(218))];
        [self loadRelateds];
    } else {
        [self loadRelateds];
    }
    
    
}

- (void)praseDataWithResult:(id)result
{
//    [self initViews];
    OBKWDetailModel *listmodel = [OBKWDetailModel objectWithKeyValues:result];
    self.detailModel = listmodel;
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:listmodel.img_uri] placeholderImage:[UIImage imageNamed:@"loadfiailed"]];
    self.categoryLabel.text = listmodel.category;
    
    self.titleLabel.text = listmodel.title;
    NSMutableAttributedString * attributedString =[NSString attributedStringWithText:self.titleLabel.text WithLineSpace:KViewHeight(7)];
    [self.titleLabel setAttributedText:attributedString];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.titleLabel.font;
    attrs[NSKernAttributeName] =[NSNumber numberWithFloat:KViewHeight(7)];
    CGRect titleContentSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - KViewWidth(10), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil];
    self.titleLabel.height = titleContentSize.size.height + KViewHeight(10);
    
    self.subtitleLabel.top = self.titleLabel.bottom;
    self.subtitleLabel.text = listmodel.subtitle;
    NSMutableAttributedString * attributedString2 =[NSString attributedStringWithText:self.subtitleLabel.text WithLineSpace:KViewHeight(5)];
    [self.subtitleLabel setAttributedText:attributedString2];
    self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableDictionary *attrs2 = [NSMutableDictionary dictionary];
    attrs2[NSFontAttributeName] = self.subtitleLabel.font;
    attrs2[NSKernAttributeName] =[NSNumber numberWithFloat:KViewHeight(5)];
    CGRect subtextSize = [self.subtitleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - KViewWidth(10), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading  attributes:attrs context:nil];
    self.subtitleLabel.height = subtextSize.size.height + KViewHeight(10);
    
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@",listmodel.author];
    self.authorLabel.top = self.subtitleLabel.bottom + KViewHeight(5);
    self.lineLabel.top = self.authorLabel.bottom + KViewHeight(20);
    self.backView.nid = listmodel.nid;
    NSString *cssString = [NSString stringWithFormat:@"<html> <head> <meta charset=\"utf-8\"> <style type=\"text/css\"> body{text-align:justify; font-size: %fpx; line-height: %fpx},td,th { color: #000;}img{ width:100%%; height:auto;text-align:left}p{ margin:0px; padding:0px;line-height:%fpx;}span{ font-size: %fpx;} </style> </head> <body>",KFont(16.0),KFont(21.0),KFont(21.0),KFont(16.0)];
    if (listmodel.content == nil) {
        listmodel.content = @"";
    }
    NSString *xString = [cssString stringByAppendingString:listmodel.content];
    NSString *endSting = @"</body> </html>";
    NSString *webString = [xString stringByAppendingString:endSting];
    [self.webView loadHTMLString:webString baseURL:nil];
    //获取webView 中的所有图片
    self.photoArrays = [self rePraseContentWithString:webString];    
    self.webView.top = self.lineLabel.bottom + KViewHeight(10);
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, self.scrollerView.contentSize.height + KViewHeight(80) + titleContentSize.size.height + subtextSize.size.height)];
    
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
                xOffset = KViewWidth(5);
                label.frame = CGRectMake(kScreenWidth -KViewWidth(20) - textSize.size.width, KViewHeight(5) + y * KViewHeight(35),textSize.size.width + KViewWidth(15), KViewHeight(30));
            }
            label.text = tagName;
            label.layer.cornerRadius = KViewWidth(15.0);
            label.layer.masksToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
//            label.backgroundColor = HWColor(225, 141, 98);
            label.font = [UIFont systemFontOfSize:KFont(13.0)];
            xOffset += textSize.size.width + KViewWidth(25);
            
            UIImageView *backImage = [[UIImageView alloc]init];
            UIImage *image = [UIImage imageNamed:@"tag_red"];
            image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:14];
            backImage.image = image;
            backImage.frame = label.frame;
            [self.topImage addSubview:backImage];
            [self.topImage addSubview:label];
        }
    }
}

- (void)praseRelatedsDataWithResult:(id)result
{
    NSNumber *code = result[@"ret_code"];
    if ([code integerValue] == 0) {
        //
        OBKWDetailModel *listmodel = [OBKWDetailModel objectWithKeyValues:result];
        OBKWListModel *kwListModel = [[OBKWListModel alloc]init];
        self.kwListModel = kwListModel;
        kwListModel.category = listmodel.category;
        kwListModel.title = listmodel.title;
        kwListModel.subtitle = listmodel.subtitle;
        kwListModel.summary = listmodel.summary;
        kwListModel.created_time = listmodel.created_time;
        kwListModel.publish_time = listmodel.publish_time;
        kwListModel.nid = listmodel.nid;
        kwListModel.img_uri = listmodel.img_uri;
        kwListModel.comment_count = listmodel.comment_count;
        CGFloat height = self.guanggaoImage.bottom;
        if (self.guangGaoModel == nil) {
            height =  self.webView.bottom + KViewHeight(20);
        }

        UILabel *grayLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, height, kScreenWidth, KViewHeight(20))];
        grayLabel2.backgroundColor = HWColor(240, 240, 240);
        [self.scrollerView addSubview:grayLabel2];
        OBKWRelatedCardView *view = [[OBKWRelatedCardView alloc]initWithFrame:CGRectMake(0, grayLabel2.bottom, kScreenWidth, KViewHeight(460))];
        [self.scrollerView addSubview:view];
//        view.backgroundColor = HWRandomColor;
        view.listModel = kwListModel;
        view.relatedCardDelegate = self;
        [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, view.bottom  - 49)];
    }
    
    
}
#pragma mark - TapActions
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:_webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [_webView stringByEvaluatingJavaScriptFromString:imgURL];
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
- (NSArray *)rePraseContentWithString:(NSString *)string
{
    NSMutableArray *picArray = [NSMutableArray array];
    NSError *error;
    OBLog(@"string = %@",string);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"http(s)?://[a-zA-Z0-9_\\.@%&/\?=:]*.(jpg|png|jpeg)" options:0 error:&error];
    if (regex != nil) {
        
        NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            if (NSNotFound != matchRange.location) {
                NSString *picUrl = [string substringWithRange:matchRange];
                [picArray addObject:picUrl];
            }
        
        }
        self.picUrlArray = picArray;
    }
    if (picArray.count > 0) {
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:picArray.count];
        for (int i =0; i< picArray.count; i++) {
            OBPhoto *photo = [[OBPhoto alloc]init];
            photo.urlString = self.picUrlArray[i];
            [photos addObject:photo];
        }
         return photos;
    }
    else
        return nil;
   
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma  mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    } else
        return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud hide:YES afterDelay:1];
    CGRect frame = webView.frame;
    frame.size.width = self.scrollerView.width;
    frame.size.height = 1;
    webView.frame = frame;
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    self.webView.frame = webView.frame;
    [self.scrollerView setContentSize:CGSizeMake(self.scrollerView.width, webView.frame.size.height + self.scrollerView.contentSize.height)];
    isFinishWebView = YES;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height)));
    if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height)< 100 && isFinishWebView ) {
        //加载相关文章
        if (!isFirst && isFinishWebView) {
            isFirst = YES;
            [self guangGao];
        }
        
    }
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
//        NSLog(@"ScrollUp now");
        self.backView.alpha = 0;
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        NSLog(@"ScrollDown now");
        self.backView.alpha = 1;
    }
    
    if (currentPostion < -kImageOriginHight) {
        CGRect f = self.topImage.frame;
        f.origin.y = currentPostion;
        f.size.height =  -currentPostion;
        self.topImage.frame = f;
        self.maskView.frame = self.topImage.bounds;
    }
}
#pragma mark - OBKWRelatedCardDelegate
- (void)didTapRelatedView
{
    OBKWDetailViewController *kwd = [[OBKWDetailViewController alloc]init];
    kwd.pageId = self.kwListModel.nid;
    [self.navigationController pushViewController:kwd animated:YES];
//    [self presentViewController:kwd animated:NO completion:nil];
}
- (void)didSelectedKWRelatedCommentButtonWithListModel:(OBKWListModel *)listModel
{
    OBCommentViewController *commentVC = [[OBCommentViewController alloc]init];
    commentVC.pageId = listModel.nid;
    commentVC.commentTitle = listModel.title;
    [self.navigationController pushViewController:commentVC animated:YES];
//    [self presentViewController:commentVC animated:YES completion:nil];
}
- (void)didSelectedKWRelatedMoreButtonWithListModel:(OBKWListModel *)listModel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    OBVisualEffectView *effview  = [[OBVisualEffectView alloc]initWithFrame:lastWindow.frame];
    self.eff = effview;
    effview.isKePing = NO;
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
- (void)backViewdidSelectedShareButton
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = [windows lastObject];
    OBVisualEffectView *effview  = [[OBVisualEffectView alloc]initWithFrame:lastWindow.frame];
    effview.visualDelegate = self;
    self.eff = effview;
    effview.isKePing = NO;
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
                if ([code integerValue] == - 9)  {
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"收藏成功"];
//                    NSInteger lastCount = self.detailModel.like_count;
//                    NSInteger currentCount = lastCount + 1;
//                    self.eff.likeCount = currentCount;
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
                if ([code integerValue] == - 9){
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
                if ([code integerValue] == - 9){
                    NSDictionary *resultDic = result[@"result"];
                    NSString *timestamp_offset = resultDic[@"timestamp_offset"];
                    self.currentTimeOffset = timestamp_offset;
                    [self didSelectedLoveButtonWithSelected:YES];
                } else if ([code integerValue] == 0) {
//                    [KLToast showToast:@"点赞成功"];
                    NSInteger lastCount = self.detailModel.like_count;
                    NSInteger currentCount = lastCount + 1;
                    self.eff.likeCount = currentCount;
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
                    //                    NSInteger lastCount = [_listModel.like_count intValue];
                    //                    if (self.bottomView.likeCount) {
                    //                        lastCount = [self.bottomView.likeCount integerValue] - 1;
                    //                    }
                    //                    NSInteger currentCount = lastCount - 1;
                    self.eff.likeCount =self.detailModel.like_count;
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

-(void)didReceiveMemoryWarning
{
    NSLog(@"OBKWDetailViewController --didReceiveMemoryWarning");
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
