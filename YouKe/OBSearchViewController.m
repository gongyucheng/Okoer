//
//  OBSearchViewController.m
//  YouKe
//
//  Created by obally on 15/10/26.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import "OBSearchViewController.h"
#import "OBSingleColorView.h"
#import "OBRecentCell.h"
#import "OBRecentSearchView.h"
#import "OBRecentDataTool.h"
#import "OBDataService.h"
#import "OBSearchDetailController.h"

#define xoffset KViewWidth(15)
@interface OBSearchViewController ()<UITextFieldDelegate,OBRecentSearchViewDelegate>
{
    MBProgressHUD *_hud;
}
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) UIImageView *searchBackImage;
@property (nonatomic, retain) UIView *hotView;
@property (nonatomic, retain) NSMutableArray *recentArray;
@property (nonatomic, retain) OBRecentSearchView *recentView;
@property (nonatomic, retain) NSArray *hotArray;
@property (nonatomic, retain) UIButton *searchButton;
@end

@implementation OBSearchViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (self.recentView && self.recentArray) {
        NSMutableArray *recentArray = [OBRecentDataTool recentDatas];
        if (recentArray.count > 0) {
            self.recentView.dataArrays = recentArray;
            self.recentArray = recentArray;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    //为imageView添加手势
    [self.view addGestureRecognizer:tap];
    self.recentArray = [NSMutableArray array];
    [self initTopView];
    [self requestHotData];
    [self initRecentView];
   
    // Do any additional setup after loading the view.
}
//初始化顶部视图
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KViewWidth(10), KViewHeight(30), KViewWidth(35), KViewWidth(24))];
    label.text = @"搜索";
    label.font = [UIFont systemFontOfSize:KFont(14.0)];
    //    backButton.backgroundColor = HWRandomColor;
//    [backButton setBackgroundImage:[UIImage imageNamed:@"u215"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:label];
    
    //搜索框
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(label.right + KViewWidth(10),label.top - KViewHeight(5), kScreenWidth -  KViewWidth(50) * 2, KViewHeight(30))];
    searchTextField.placeholder = @"搜索商品，测评报告，资讯文章";
    [searchTextField setValue:HWColor(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.tag = 100;
    searchTextField.textColor = [UIColor blackColor];
    [searchTextField resignFirstResponder];
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbghover.png"]];
    [visualEffect addSubview:searchTextField];
    self.searchTextField = searchTextField;
    // 文字改变的通知
    [OBNotificationCenter addObserver:self selector:@selector(searchTextDidChange) name:UITextFieldTextDidChangeNotification object:searchTextField];
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(searchTextField.left - KViewWidth(4), searchTextField.bottom - KViewHeight(6), searchTextField.width + KViewWidth(8), KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"searchline2"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    self.searchBackImage = backImage;
    [visualEffect addSubview:backImage];

    //优品
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(35), KViewHeight(25), KViewWidth(26), KViewHeight(26))];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"app_0000_search26_9"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton = searchButton;
    self.searchButton.enabled = NO;
    [visualEffect addSubview:searchButton];
}
//请求热搜关键词
- (void)requestHotData
{
     _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [OBDataService requestWithURL:OBHotDataUrl params:nil httpMethod:@"GET" completionblock:^(id result) {
        [_hud hide:YES];
        NSNumber *code = result[@"ret_code"];
        if ([code integerValue] == 0) {
            //请求成功
            NSArray *datas = result[@"data"];
            self.hotArray = datas;
            [self initHotViewWithdatas:datas];
        }else {
            NSString *err_msg = result[@"err_msg"];
            [MBProgressHUD showAlert:err_msg];
        }
    } failedBlock:^(id error) {
        [_hud hide:YES];
    }];

}
//初始化最近搜索记录
- (void)initRecentView
{

    OBRecentSearchView *view = [[OBRecentSearchView alloc]initWithFrame:CGRectMake(0, KViewHeight(205) + KViewHeight(80), kScreenWidth, 0)];
    self.recentView = view;
    view.recentSearchViewDelegate = self;
    NSMutableArray *recentArray = [OBRecentDataTool recentDatas];
    if (recentArray.count > 0) {
        view.dataArrays = recentArray;
        self.recentArray = recentArray;
    }
//    view.y = self.hotView.bottom;
    [self.view addSubview:view];
}

//根据热词进行布局
- (void)initHotViewWithdatas:(NSArray *)datas
{
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, self.effectView.bottom, kScreenWidth, KViewHeight(210))];
    searchView.backgroundColor = [UIColor whiteColor];
    self.hotView = searchView;
    [self.view addSubview:searchView];
    CGFloat heightEdge = KViewHeight(15);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xoffset, heightEdge, KViewWidth(200), KViewHeight(30))];
    label.text = @"大家都在搜";
    label.font = [UIFont systemFontOfSize:KFont(13.0)];
    [searchView addSubview:label];
    
    CGFloat xOffset = KViewWidth(15);
    CGFloat lasty = 0;
    NSInteger index = 0;
    //添加标签
    if (datas.count > 0 ) {
        for (int i = 0; i < datas.count; i++) {
            NSString *tagName = datas[i];
            CGRect textSize = [tagName boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(13.0)]} context:nil];
            NSInteger width = xOffset;
            NSInteger y = (xOffset + textSize.size.width + KViewWidth(15))/kScreenWidth + index;
            NSInteger x = width % (int)kScreenWidth;
            if (x + textSize.size.width + KViewWidth(15) > kScreenWidth) {
                x = xOffset;
            }
            UIButton *hotButton = [[UIButton alloc]initWithFrame:CGRectMake(x ,label.bottom + heightEdge + y * KViewHeight(45),textSize.size.width + KViewWidth(15), KViewHeight(40))];
            [hotButton addTarget:self action:@selector(hotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            hotButton.tag = i + 100;
            if (y != lasty && y != 3) {
                index++;
                lasty = y;
                xOffset = KViewWidth(15);
                NSInteger width = xOffset;
                x = width % (int)kScreenWidth;
                hotButton.frame = CGRectMake(x , label.bottom + heightEdge + y * KViewHeight(45),textSize.size.width + KViewWidth(15), KViewHeight(40));
            } else if (y == 3) {
                return;
            }
            [hotButton setTitle:tagName forState:UIControlStateNormal];
            hotButton.layer.cornerRadius = KViewWidth(15);
            hotButton.layer.masksToBounds = YES;
            hotButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [hotButton setTitleColor:HWColor(158, 158, 158) forState:UIControlStateNormal];
            hotButton.titleLabel.font = [UIFont systemFontOfSize:KFont(13.0)];
            xOffset += textSize.size.width + KViewHeight(25);
            
            UIImageView *backImage = [[UIImageView alloc]init];
            UIImage *image = [UIImage imageNamed:@"tag2"];
             UIImage *image1 = [UIImage imageNamed:@"tag1"];
            image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:14];
             image1 = [image1 stretchableImageWithLeftCapWidth:15 topCapHeight:14];
            backImage.image = image;
            backImage.frame = hotButton.frame;
            [hotButton setBackgroundImage:image forState:UIControlStateNormal];
            [hotButton setBackgroundImage:image1 forState:UIControlStateHighlighted];
            [searchView addSubview:backImage];
            [searchView addSubview:hotButton];
        }
    }

}

- (void)tapAction
{
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
    
}
#pragma mark - Actions
- (void)searchButtonAction
{
    NSString *searchString = self.searchTextField.text;
    for (int i = 0; i < self.recentArray.count; i ++) {
        NSString *string = self.recentArray[i];
        if ([string isEqualToString:searchString]) {
            [self.recentArray removeObject:string];
        }
    }

    if (self.recentArray.count > 0) {
        [self.recentArray insertObject:searchString atIndex:0];
    } else
        [self.recentArray addObject:searchString];
    
    if (self.recentArray.count > 5) {
        for (int i = 5; i < self.recentArray.count; i ++) {
            [self.recentArray removeObjectAtIndex:i];
        }
    }
    
    [OBRecentDataTool saveRecentData:self.recentArray];
    self.recentView.dataArrays = self.recentArray;
    OBSearchDetailController *searchVC = [[OBSearchDetailController alloc]init];
    searchVC.searchString = searchString;
    self.searchTextField.text = nil;
    [self.navigationController pushViewController:searchVC animated:YES];
//    [self.view.containerViewController presentViewController:searchVC animated:NO completion:nil];
}
- (void)backButtonAction
{
    
}
- (void)hotButtonAction:(UIButton*)hotButton
{
    NSInteger tag = hotButton.tag - 100;
    NSString *hotString = self.hotArray[tag];
    self.searchTextField.text = hotString;
    [self searchButtonAction];
//    [self searchTextDidChange];
}
/**
 * 监听文字改变
 */
- (void)searchTextDidChange
{
    if ([self.searchTextField.text trim].length > 0) {
        self.searchButton.enabled = YES;
    } else
        self.searchButton.enabled = NO;
    if (self.searchTextField.text.length > 48) {
        self.searchTextField.text = [self.searchTextField.text substringToIndex:48];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    UIImage *image1 = [UIImage imageNamed:@"searchline1"];
    image1 = [image1 stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    self.searchBackImage.image = image1;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 48 ) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 48) {
        textField.text = [textField.text substringToIndex:48];
    }
}
- (void)recentSearchViewWithSelectedViewTag:(NSInteger)tag
{
    NSString *hotString = self.recentArray[tag];
    self.searchTextField.text = hotString;
    [self searchButtonAction];
//    [self searchTextDidChange];
}
- (void)didReceiveMemoryWarning {
     NSLog(@"OBSearchViewControllerdidReceiveMemoryWarning");
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
