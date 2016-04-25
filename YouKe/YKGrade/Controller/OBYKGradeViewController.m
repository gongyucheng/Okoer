//
//  OBYKGradeViewController.m
//  YouKe
//
//  Created by obally on 15/7/31.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBYKGradeViewController.h"
#import "OBRecommendController.h"
#import "OBGradeViewController.h"
#import "OBPinPaiViewController.h"
#import "OBScrollerView.h"
#import "MBProgressHUD.h"
#import "OBSingleColorView.h"

@interface OBYKGradeViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIImage *viewImage;
    UIImageView *pageImageView ;
    CGFloat _userSelectedButtonTag;
    //    NSMutableArray *_controllerArray;
}

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,retain)UIScrollView *rootScrollView;
@property (nonatomic, retain)UIView *topView;
@property (nonatomic, retain) UILabel *selectedLabel;
@property (nonatomic, strong) OBPinPaiViewController *kePing;
@property (nonatomic, strong) OBGradeViewController *keWen;
@property (nonatomic, retain) NSMutableArray *controllerArray;
@property(nonatomic,assign)NSInteger userSelectedChannelID;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@end

@implementation OBYKGradeViewController
- (void)dealloc
{
    [OBNotificationCenter removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _userSelectedButtonTag = 100;
    
    [OBNotificationCenter addObserver:self selector:@selector(didSlide) name:@"OBDidSlide" object:nil];
    [OBNotificationCenter addObserver:self selector:@selector(didDeSlide) name:@"OBDidDeSlide" object:nil];
    OBSingleColorView *refreshHeaderView = [[OBSingleColorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KViewHeight(60))];
    [self.view addSubview:refreshHeaderView];
    self.controllerArray  = [NSMutableArray array];
    //2.设置侧滑按钮
    [self initViews];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark -
- (void)initViews
{
    self.userSelectedChannelID = 100;
    NSArray *array = @[@"优恪评级",@"品牌墙"];
    CGFloat topViewHeight =  KViewHeight(60);
    //1.创建顶部Button
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, topViewHeight)];
    self.topView = topView;
    
    //    vibrancyEffect
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffect =  [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView = visualEffect;
    visualEffect.frame = topView.frame;
    visualEffect.alpha = 1.0;
    
    CGFloat topButtonwidth = KViewWidth(100);
    CGFloat topButtonheight = KViewHeight(60);
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(topButtonwidth * i, KViewHeight(12), topButtonwidth, topButtonheight)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
        [button setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100 + i;
        
        if (i == 0) {
            [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
            button.selected = YES;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
            
        }
        [button addTarget:self action:@selector(didSelectedTopButton:) forControlEvents:UIControlEventTouchUpInside];
        [visualEffect addSubview:button];
    }
    UILabel *selectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, topView.height - 4, topButtonwidth, 4)];
    selectedLabel.backgroundColor = HWColor(35, 144, 79);
    self.selectedLabel = selectedLabel;
    //    [visualEffect addSubview:selectedLabel];
    
    [topView addSubview:visualEffect];
    [self.view addSubview:topView];
    //2.创建下面的滑动view
    //创建主滚动视图
    UIScrollView *rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topViewHeight, kScreenWidth, kScreenHeight - topViewHeight)];
    rootScrollView.delegate = self;
    rootScrollView.pagingEnabled = YES;
    rootScrollView.bounces = NO;
    rootScrollView.showsVerticalScrollIndicator = NO;
    rootScrollView.showsHorizontalScrollIndicator = NO;
    self.rootScrollView = rootScrollView;
    rootScrollView.contentSize = CGSizeMake(kScreenWidth * array.count, 0);
    
    OBGradeViewController *keWn = [[OBGradeViewController alloc]init];
    keWn.view.frame = CGRectMake( 0, 0, kScreenWidth, rootScrollView.height);
    self.keWen = keWn;
    [rootScrollView addSubview:keWn.view];
    [keWn loadData];
    OBPinPaiViewController *kp= [[OBPinPaiViewController alloc]init];
    kp.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [rootScrollView addSubview:kp.view];
    [_controllerArray addObject:keWn];
    [_controllerArray addObject:kp];
    
    [_rootScrollView setContentOffset:CGPointMake((_userSelectedButtonTag - 100) * kScreenWidth, 0) animated:NO];
    [self.view addSubview:rootScrollView];
    
}

- (void)didSelectedTopButton:(UIButton *)button
{
    [button setTitleColor:HWColor(84, 167, 86) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:KFont(17.0)];
    NSInteger tag = button.tag - 100;
    
    if (button.tag != _userSelectedButtonTag) {
        UIButton *lastButton = (UIButton *)[self.effectView viewWithTag:_userSelectedButtonTag];
        lastButton.selected = NO;
        [lastButton setTitleColor:HWColor(97, 97, 97) forState:UIControlStateNormal];
        lastButton.titleLabel.font = [UIFont systemFontOfSize:KFont(16.0)];
        _userSelectedButtonTag = button.tag;
        
        [UIView animateWithDuration:0.35 animations:^{
            
        }completion:^(BOOL finished) {
            if (finished) {
                if (tag == 1 && self.kePing == nil) {
                    OBPinPaiViewController *kp = _controllerArray[tag];
                    self.kePing = kp;
                    [kp loadData];
                }
                [self.rootScrollView setContentOffset:CGPointMake(tag * kScreenWidth, 0) animated:NO];
                
            }
        }];
    }
    
    
    
}

- (void)scrollHandlePan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture locationInView:self.view];
    if (point.x < 50 && self.view.x == 0) {
        panGesture.enabled = NO;
    } else
        panGesture.enabled = YES;
    
}

#pragma mark -

#pragma mark - 主视图逻辑方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint point =  [scrollView.panGestureRecognizer locationInView:self.view];
    CGPoint transpoint = [scrollView.panGestureRecognizer translationInView:self.view];
    if (point.x < 50 && transpoint.x >= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            scrollView.scrollEnabled = NO;
            
        });
        
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int tag = (int)scrollView.contentOffset.x / kScreenWidth + 100;
    if (_userSelectedButtonTag != tag) {
        UIButton *button = (UIButton *)[self.topView viewWithTag:tag];
        [self didSelectedTopButton:button];
    }
    
    
}
- (void)didSlide
{
    self.rootScrollView.scrollEnabled= NO;
    for (UIButton *button in self.topView.subviews) {
        button.userInteractionEnabled = NO;
    }
}
- (void)didDeSlide
{
    self.rootScrollView.scrollEnabled= YES;
    for (UIButton *button in self.topView.subviews) {
        button.userInteractionEnabled = YES;
    }
}

-(void)didReceiveMemoryWarning
{
    NSLog(@"OBYKGradeViewController--didReceiveMemoryWarning");
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
