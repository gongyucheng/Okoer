//
//  OBSearchDetailController.m
//  YouKe
//
//  Created by obally on 15/10/28.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import "OBSearchDetailController.h"
#import "OBSingleColorView.h"
#import "OBRecentDataTool.h"
#import "OBMyCollectionTableView.h"
#import "OBSearchProductController.h"
#import "OBSearchKWController.h"
#import "OBSearchKPController.h"
#define topViewHeight KViewHeight(35)
@interface OBSearchDetailController ()<UITextFieldDelegate,UIScrollViewDelegate,BaseTableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, retain) UIVisualEffectView *topEffectView;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) UIImageView *searchBackImage;
@property (nonatomic, retain) NSMutableArray *recentArray;
@property (nonatomic, retain) UIButton *searchButton;
@property (nonatomic, retain)UIView *topView;
@property(nonatomic,assign)NSInteger currentpageid;
@property(nonatomic,assign)NSInteger selectedPage;
@property (nonatomic, retain) UIScrollView *rootScrollView;
@property (nonatomic, retain) OBMyCollectionTableView *myCollectionTableView;
@property (nonatomic, retain) OBSearchProductController *searchProduct;
@property (nonatomic, retain) OBSearchKWController *searchKW;
@property (nonatomic, retain) OBSearchKPController *searchKP;
@property (nonatomic, retain) NSMutableArray *controllerArray;
@property (nonatomic, retain) NSArray *topArray;
@property(nonatomic,assign)BOOL isFirstInit;
@end

@implementation OBSearchDetailController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     self.recentArray = [NSMutableArray array];
    self.controllerArray  = [NSMutableArray array];
    self.isFirstInit = YES;
    [self initTopView];
    [self initRootScrollView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchDetailtapAction)];
    tap.delegate = self;
    //为imageView添加手势
//    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
- (void)searchDetailtapAction
{
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
}
//初始化顶部视图
- (void)initTopView
{
    //头部----------------------
    OBSingleColorView *refreshHeaderView = [[OBSingleColorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(95))];
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
    [backButton setBackgroundImage:[UIImage imageNamed:@"u215"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [visualEffect addSubview:backButton];
    
    //搜索框
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(backButton.right + KViewWidth(15),backButton.top - KViewHeight(5), kScreenWidth -  KViewWidth(50) * 2, KViewHeight(30))];
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.placeholder = @"搜索商品，测评报告，资讯文章";
    [searchTextField setValue:HWColor(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
    searchTextField.delegate = self;
    searchTextField.text = self.searchString;
    searchTextField.textColor = [UIColor blackColor];
    [searchTextField resignFirstResponder];
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbghover.png"]];
    // 文字改变的通知
    [OBNotificationCenter addObserver:self selector:@selector(searchTextDidChange) name:UITextFieldTextDidChangeNotification object:searchTextField];
    [visualEffect addSubview:searchTextField];
    self.searchTextField = searchTextField;
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(searchTextField.left - KViewWidth(4), searchTextField.bottom - KViewHeight(6), searchTextField.width + KViewWidth(8), KViewHeight(10))];
    UIImage *image = [UIImage imageNamed:@"searchline2"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backImage.image = image;
    self.searchBackImage = backImage;
    [visualEffect addSubview:backImage];
    
    //优品
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - KViewWidth(35), KViewHeight(25), KViewWidth(24), KViewHeight(24))];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"app_0000_search26_9"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton = searchButton;
    self.searchButton.enabled = NO;
    [visualEffect addSubview:searchButton];
    //1.创建顶部Button
    self.topArray = @[@"商品",@"报告",@"资讯"];
    CGFloat xOffset = KViewWidth(70);
    for (int i = 0; i < self.topArray.count; i ++) {
        if (self.topArray.count > 0 ) {
            NSString *title = self.topArray[i];
            CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KFont(14.0)]} context:nil];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xOffset , KViewHeight(55), rect.size.width + KViewWidth(20), topViewHeight)];
            [button setTitle:title forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
            [button setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 100;
            
            if (i == 0) {
                [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
                button.selected = YES;
                button.titleLabel.font = [UIFont boldSystemFontOfSize:KFont(15.0)];
                self.currentpageid = button.tag;
            }
            [button addTarget:self action:@selector(didSelected:) forControlEvents:UIControlEventTouchUpInside];
            [visualEffect addSubview:button];
            xOffset += rect.size.width + KViewWidth(40);
        }
        
    }
    
}
- (void)initRootScrollView
{
    //2.创建下面的滑动view
    //创建主滚动视图
    UIScrollView *rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.effectView.bottom, kScreenWidth, kScreenHeight - topViewHeight)];
    rootScrollView.delegate = self;
    rootScrollView.pagingEnabled = YES;
    rootScrollView.bounces = NO;
    rootScrollView.showsVerticalScrollIndicator = NO;
    rootScrollView.showsHorizontalScrollIndicator = NO;
    self.rootScrollView = rootScrollView;
    rootScrollView.contentSize = CGSizeMake(kScreenWidth * self.topArray.count, 0);
    //搜索的商品
    OBSearchProductController *searchP = [[OBSearchProductController alloc]init];
    searchP.view.frame = CGRectMake( 0, 0, kScreenWidth, rootScrollView.height);
    if (self.isFirstInit) {
        self.searchProduct = searchP;
         [searchP loadDataWithSearchString:self.searchString];
    }
    
    [rootScrollView addSubview:searchP.view];
   
    //搜索的报告
    OBSearchKPController *kp= [[OBSearchKPController alloc]init];
    kp.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [rootScrollView addSubview:kp.view];
    
    //搜索的资讯
    OBSearchKWController *kw= [[OBSearchKWController alloc]init];
    kw.view.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight);
    [rootScrollView addSubview:kw.view];
    
    [self.controllerArray addObject:searchP];
    [self.controllerArray addObject:kp];
    [self.controllerArray addObject:kw];
    
    [_rootScrollView setContentOffset:CGPointMake((self.currentpageid - 100) * kScreenWidth, 0) animated:NO];
    [self.view addSubview:rootScrollView];
}
- (void)didSelected:(UIButton *)button
{
    [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:KFont(15.0)];
    NSInteger tag = button.tag - 100;
    if (button.tag != self.currentpageid || !self.isFirstInit) {
        
        UIButton *lastButton = (UIButton *)[self.effectView viewWithTag:self.currentpageid];
        if (lastButton.tag != button.tag) {
            lastButton.selected = NO;
            [lastButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
            lastButton.titleLabel.font = [UIFont systemFontOfSize:KFont(14.0)];
            
        }
        self.currentpageid = button.tag;
        [UIView animateWithDuration:0.35 animations:^{
            
        }completion:^(BOOL finished) {
            if (finished) {
                if (tag == 1 && self.searchKP == nil) {
                    OBSearchKPController *kp = self.controllerArray[tag];
                    self.searchKP = kp;
                    [kp loadDataWithSearchString:self.searchString];
                } else if (tag == 2 && self.searchKW == nil) {
                    OBSearchKWController *kw = self.controllerArray[tag];
                    self.searchKW = kw;
                    [kw loadDataWithSearchString:self.searchString];
                }else if (tag == 0 && self.searchProduct == nil) {
                    OBSearchProductController *searchProduct = self.controllerArray[tag];
                    self.searchProduct = searchProduct;
                    [searchProduct loadDataWithSearchString:self.searchString];
                }
                [self.rootScrollView setContentOffset:CGPointMake(tag * kScreenWidth, 0) animated:NO];
                
            }
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int tag = (int)scrollView.contentOffset.x / kScreenWidth + 100;
    if (self.currentpageid != tag) {
        UIButton *button = (UIButton *)[self.effectView viewWithTag:tag];
        [self didSelected:button];
    }
    
    
}
#pragma mark - searchField Action
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Actions
- (void)searchButtonAction
{
    NSMutableArray *recentArray = [OBRecentDataTool recentDatas];
    if (recentArray.count > 0) {
        self.recentArray = recentArray;
    }
    NSString *searchString = self.searchTextField.text;
    self.searchString = searchString;
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
    [self.rootScrollView removeFromSuperview];
    self.rootScrollView = nil;
    self.searchProduct = nil;
    self.searchKP = nil;
    self.searchKW = nil;
    [self.controllerArray removeAllObjects];
    self.isFirstInit = NO;
    
    [self initRootScrollView];
     UIButton *lastButton = (UIButton *)[self.effectView viewWithTag:100];
    [self didSelected:lastButton];
    [self.searchTextField resignFirstResponder];
}
- (void)backButtonAction
{
//    self.navigationController.navigationBarHidden = NO;
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)didReceiveMemoryWarning {
     NSLog(@"OBSearchDetailViewControllerdidReceiveMemoryWarning");
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
