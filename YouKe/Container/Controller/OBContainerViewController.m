//
//  OBContainerViewController.m
//  YouKe
//
//  Created by obally on 15/7/24.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBContainerViewController.h"
#import "OBKeWenAndKePingController.h"
#import "OBSlideViewController.h"
#import "OBYKGradeViewController.h"
#import "OBKeTangController.h"
#import "OBAboutViewController.h"
#import "OBBaseViewController.h"
#import "OBColorRefresh.h"
#import "OBRecommendController.h"
#import "OBSearchViewController.h"
#import "OBGuangGaoModel.h"
#import "OBIDTool.h"

@interface OBContainerViewController ()<UIGestureRecognizerDelegate,OBKeWenAndKePingControllerDelegate>
@property (nonatomic, strong) OBKeWenAndKePingController *keWenVC;
@property (nonatomic, strong) OBSlideViewController *slideVC;
@property (nonatomic, strong) OBYKGradeViewController *gradeVC;
@property (nonatomic, strong) OBKeTangController *keTangVC;
@property (nonatomic, strong) OBAboutViewController *aboutVC;
@property (nonatomic, strong) OBSearchViewController *searchVC;
@property (nonatomic, strong) UIViewController *currentVC;
@property(nonatomic,assign)NSInteger currentIndex;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, retain) UIImageView *introduceImage;
@property (nonatomic, retain) UIView *introduceView;
@property(nonatomic,assign)BOOL isCurrentVersion;
@property (nonatomic, retain) UIImageView *openImageView;
@end

@implementation OBContainerViewController
- (void)dealloc
{
    [OBNotificationCenter removeObserver:self];
}
- (OBKeWenAndKePingController *)keWenVC
{
    if (!_keWenVC) {
        self.keWenVC = [[OBKeWenAndKePingController alloc]init];
        self.keWenVC.kwAndkpDelegate = self;
        self.keWenVC.view.frame = self.view.frame;
//        self.keWenVC.kwpDelegete = self;
    }
    return _keWenVC;
}
- (OBSlideViewController *)slideVC
{
    if (!_slideVC) {
        self.slideVC = [[OBSlideViewController alloc]init];
        self.slideVC.view.frame = self.view.frame;
    }
    return _slideVC;
}

- (OBKeTangController *)keTangVC
{
    if (!_keTangVC) {
        self.keTangVC = [[OBKeTangController alloc]init];
        self.keTangVC.view.frame = self.view.frame;
    }
    return _keTangVC;
}

- (OBYKGradeViewController *)gradeVC
{
    if (!_gradeVC) {
        self.gradeVC = [[OBYKGradeViewController alloc]init];
        self.gradeVC.view.frame = self.view.frame;
    }
    return _gradeVC;
}

- (OBAboutViewController *)aboutVC
{
    if (!_aboutVC) {
        self.aboutVC = [[OBAboutViewController alloc]init];
        self.aboutVC.view.frame = self.view.frame;
    }
    return _aboutVC;
}
- (OBSearchViewController *)searchVC
{
    if (!_searchVC) {
        self.searchVC = [[OBSearchViewController alloc]init];
        self.searchVC.view.frame = self.view.frame;
    }
    return _searchVC;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.openImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:self.openImageView];
        //        sleep(2);
    }
    return self;
}
/**
 *  侧滑按钮
 */
- (void)setupSlideButton
{
    
    //侧滑按钮
    UIImageView *slideImage = [[UIImageView alloc]initWithFrame:CGRectMake(KbuttonEdgeWidth, kScreenHeight - KbuttonEdgeWidth - KbuttonWidth, KbuttonWidth, KbuttonWidth)];
    slideImage.userInteractionEnabled = YES;
    slideImage.image = [UIImage imageNamed:@"icon_0003_Menu48"];
    UITapGestureRecognizer *slideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideTapped)];
    slideTap.delegate = self;
    [slideImage addGestureRecognizer:slideTap];
    
    slideImage.layer.cornerRadius = slideImage.height/2;
    slideImage.backgroundColor = [UIColor grayColor];
    slideImage.alpha = 0.7;
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];;
    [self.view addSubview:slideImage];
    
    self.slideImage = slideImage;
    [self.view bringSubviewToFront:self.slideImage];
    
}

- (void)slideTapped
{
    
    if (self.currentView.x == 0) {
        _isSlide = YES;
    } else
        _isSlide = NO;
    
    if (_isSlide) {
        [OBNotificationCenter postNotificationName:OBDidSlideNotification object:nil];
        
    }else
        [OBNotificationCenter postNotificationName:OBDidDeSlideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadguangGao];
    
    //新手介绍
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        self.isCurrentVersion = YES;
    } else
        self.isCurrentVersion = NO;
    self.currentIndex = 100;
    [OBNotificationCenter addObserver:self selector:@selector(receivedSlideNotification) name:OBDidSlideNotification object:nil];
    [OBNotificationCenter addObserver:self selector:@selector(receivedDeSlideNotification) name:OBDidDeSlideNotification object:nil];
    self.view.backgroundColor = HWColor(48, 48, 60);
    
    //1.将侧滑控制器View添加到当前控制器
    [self.view addSubview:self.slideVC.view];
    
    //2.将资讯报告控制器View添加到当前控制器
    self.keWenVC.view.tag = 100;
    self.currentVC = self.keWenVC;
    self.keWenVC.jblastReadPage = self.jblastReadPage;
    [self.view addSubview:self.keWenVC.view];
    __weak OBContainerViewController *this = self;
    self.slideVC.block = ^(NSInteger index){
        OBContainerViewController *strongSelf = this;
        if (index == 100 ) {
            [MobClick event:@"newspv"];
            [strongSelf releaseSubViewWithAnimationWithVC:strongSelf.keWenVC withIndex:index ];
        } else if (index == 101 ) {
            [MobClick event:@"brand"];
            [strongSelf releaseSubViewWithAnimationWithVC:strongSelf.gradeVC withIndex:index];
        }else if (index == 102) {
            [MobClick event:@"okoerba"];
            [strongSelf releaseSubViewWithAnimationWithVC:strongSelf.keTangVC withIndex:index];
        }else if (index == 103) {
            [MobClick event:@"searchokoer"];
            [strongSelf releaseSubViewWithAnimationWithVC:strongSelf.searchVC withIndex:index];
        }else if (index == 104) {
            [MobClick event:@"aboutokoer"];
            [strongSelf releaseSubViewWithAnimationWithVC:strongSelf.aboutVC withIndex:index];
        }

    };
    
    //添加滑动手势
    UISwipeGestureRecognizer *rightswipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRecognizer:)];
    rightswipe.direction = UISwipeGestureRecognizerDirectionRight;
    rightswipe.delegate = self;
    [self.view addGestureRecognizer:rightswipe];
    
    UISwipeGestureRecognizer *leftswipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRecognizer:)];
    leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftswipe.delegate = self;
    [self.view addGestureRecognizer:leftswipe];
    
    if (!self.isCurrentVersion) {
        UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:view];
        UIImageView *introduce = [[UIImageView alloc]initWithFrame:view.frame];
        introduce.image = [UIImage imageNamed:@"lead2"];
        [view addSubview:introduce];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - KViewWidth(165))/2, kScreenHeight - KViewHeight(150), KViewWidth(165), KViewHeight(77))];
        [button setImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(deleButton) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = HWRandomColor;
        [view addSubview:button];
        self.introduceImage = introduce;
        self.introduceView = view;
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
//    [self setupSlideButton];
}
- (void)deleButton
{
    [self.introduceView removeFromSuperview];
}
- (void)loadguangGao
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@0 forKey:@"page"];
    [params setObject:@1 forKey:@"page_rows"];
    [params setObject:@0 forKey:@"nid"];
    
    [OBDataService requestWithURL:OBGuangGaoUrl params:params httpMethod:@"GET" completionblock:^(id result) {
        [self praseGuanggaoWithResult:result];
        
    } failedBlock:^(id error) {
        
    }];
}
- (void)praseGuanggaoWithResult:(id)result
{
    NSArray *array = result[@"data"];
    if (array.count > 0) {
        NSInteger y = arc4random() % array.count;
        NSDictionary *dic = array[y];
        OBGuangGaoModel *model = [OBGuangGaoModel objectWithKeyValues:dic];
        model.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.img_uri]]];
        [OBIDTool saveAccount:model];
        
    }
    
    
}

//新手介绍
- (void)introduceTapAction:(UISwipeGestureRecognizer *)tap
{
    [self.introduceImage removeFromSuperview];
    
}
- (void)releaseSubViewWithAnimationWithVC:(UIViewController *)vc withIndex:(NSInteger)index
{
    self.currentVC = vc;
//    self.slectedcurrentVC = vc;
    UIView *view = [self.view viewWithTag:self.currentIndex];
    [view removeFromSuperview];
    vc.view.x = KSlideWidth;
    [self.view addSubview:vc.view];
    
    vc.view.tag = index;
    self.currentIndex = index;
    [self receivedDeSlideNotification];
    [self.view bringSubviewToFront:self.slideImage];

}
//侧滑
- (void)receivedSlideNotification
{
    UIView *view = [self.view viewWithTag:self.currentIndex];
    
    [UIView animateWithDuration:0.5 animations:^{
        view.x = KSlideWidth;
        view.y = 20;
        self.slideImage.x = KbuttonEdgeWidth + KSlideWidth;
        [self addtapViewWithX:view.x];
        self.currentView = view;
    }];
    [OBNotificationCenter postNotificationName:@"OBDidSlide" object:nil];
//    [OBNotificationCenter postNotificationName:OBDidSlideNotification object:nil];
}

//侧滑回来
- (void)receivedDeSlideNotification
{
    UIView *view = [self.view viewWithTag:self.currentIndex];
    [UIView animateWithDuration:0.5 animations:^{
        view.x = 0;
        view.y = 0;
        self.slideImage.x = KbuttonEdgeWidth;
        [self removeTapView];
        self.currentView = view;
    }];
    [OBNotificationCenter postNotificationName:@"OBDidDeSlide" object:nil];
//    [OBNotificationCenter postNotificationName:OBDidDeSlideNotification object:nil];
}

- (void)swipeRecognizer:(UISwipeGestureRecognizer *)reg
{
    
    CGPoint point = [reg locationInView:self.view];
    OBLog(@"point.x %f,pont.y %f",point.x,point.y);
    
    if (reg.direction == UISwipeGestureRecognizerDirectionRight && point.x < 50&& self.currentVC.view.x == 0) {
        //        [OBNotificationCenter postNotificationName:OBDidSlideNotification object:nil];
        [self receivedSlideNotification];
        if (!self.isCurrentVersion) {
            [self.introduceView removeFromSuperview];
        }
        
    } else if (reg.direction == UISwipeGestureRecognizerDirectionLeft && point.x > KSlideWidth && self.currentVC.view.x != 0) {
        //        [OBNotificationCenter postNotificationName:OBDidDeSlideNotification object:nil];
        [self receivedDeSlideNotification];
    }
   
}
- (void)addtapViewWithX:(CGFloat)x
{
    UIView *tapView = [[UIView alloc]initWithFrame:self.view.frame];
    tapView.x = x;
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [tapView addGestureRecognizer:tap];
    [self.view addSubview:tapView];
    self.tapView = tapView;
    
}
- (void)removeTapView
{
    if (self.tapView) {
        [self.tapView removeFromSuperview];
    }
}
- (void)tapAction
{
    [self receivedDeSlideNotification];
}

- (void)didSelectedChatButtonCallUpButton
{

}
#pragma  mark -  增加广告页
- (void)loadOpenView
{
    [MobClick event:@"boot"];
//    self.delaytime += 2;
    
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

-(void)didReceiveMemoryWarning
{
    NSLog(@"OBContainerViewController --didReceiveMemoryWarning");
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
