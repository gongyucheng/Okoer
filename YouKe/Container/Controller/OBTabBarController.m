//
//  OBTabBarController.m
//  YouKe
//
//  Created by obally on 15/12/28.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import "OBTabBarController.h"
#import "OBKeWenAndKePingController.h"
#import "OBYKGradeViewController.h"
#import "OBSearchViewController.h"
#import "OBAboutViewController.h"
#import "OBPersonalViewController.h"
#import "OBLoginViewController.h"
#import "OBIDTool.h"
@interface OBTabBarController ()<UITabBarControllerDelegate>
//@property(nonatomic,assign)NSInteger selectedIndex;
//@property(nonatomic,assign)BOOL isSlected;
//@property (nonatomic, retain) UIImageView *tabbarView;
@property (nonatomic, retain) UIImageView *openImageView;
@property(nonatomic,assign)CGFloat delaytime;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *selectedImages;
@property (nonatomic, retain) UIViewController *lastViewController;
@end

@implementation OBTabBarController
- (NSArray *)images
{
    if (!_images) {
        self.images = [[NSArray alloc] init];
    }
    return _images;
}
- (NSArray *)selectedImages
{
    if (!_selectedImages) {
        self.selectedImages = [[NSArray alloc] init];
    }
    return _selectedImages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    //1.创建子控制器
    [self initViewControllers];
    //2.自定义tabbar
    [self createTabBarItems];
    
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
-(void)createTabBarItems
{
    self.view.backgroundColor = [UIColor whiteColor];
    //    NSArray * itemTitleArray = @[@"热图",@"发现",@" ",@"沃摄",@"我的"];
    NSArray * itemPicArray = @[
                               @"read_icon.png",
                               @"goods_icon.png",
                               @"search_icon.png",
                               @"my_icon.png",
                               ];
    NSArray * selectPicArray = @[
                                 @"read_s_icon.png",
                                 @"goods_s_icon.png",
                                 @"search_s_icon.png",
                                 @"my_s_icon.png",
                                 
                                 ];
    NSArray *titleArray = @[@"阅读",@"优品",@"搜索",@"我"];
    
    for (int i = 0; i<self.tabBar.items.count; i++) {
        UITabBarItem * item = [[UITabBarItem alloc] init];
        item = self.tabBar.items[i];
        
        if (IOS7) {
            //xcode6中的一些api方法被废弃了同时tabbar上图片的渲染方式发生了改变,必须设置渲染方式
            UIImage *itemPic = [[UIImage imageNamed:itemPicArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *selectPic = [[UIImage imageNamed:selectPicArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item = [item initWithTitle:titleArray[i] image:itemPic selectedImage:selectPic];
            item.tag = i;
        }
        else
        {
            item.tag = i;
        }
    }
    
    //修改Title选中的颜色--状态是选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:HWColor(27, 166, 84)} forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:HWColor(108, 108, 108)} forState:UIControlStateNormal];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_beijing_ios"]];
    self.selectedIndex = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6)
    {
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -10)];
}


- (void)initViewControllers
{
    OBKeWenAndKePingController * vc1=[[OBKeWenAndKePingController alloc] init];
    UINavigationController * nvc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    OBYKGradeViewController * vc2 = [[OBYKGradeViewController alloc] init];
    UINavigationController * nvc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    OBSearchViewController * vc3=[[OBSearchViewController alloc] init];
    UINavigationController * nvc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    
//    OBAboutViewController * vc4 = [[OBAboutViewController alloc] init];
//    UINavigationController * nvc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    OBPersonalViewController * vc4 = [[OBPersonalViewController alloc] init];
    UINavigationController * nvc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    
    self.viewControllers = @[nvc1,nvc2,nvc3,nvc4];
//    self.viewControllers = @[vc1,vc2,vc3,vc4];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController.childViewControllers[0] isKindOfClass:[OBKeWenAndKePingController class]]) {
        [MobClick event:@"newspv"];
    } else if ([viewController.childViewControllers[0] isKindOfClass:[OBYKGradeViewController class]]){
        [MobClick event:@"brand"];
    } else if ([viewController.childViewControllers[0] isKindOfClass:[OBSearchViewController class]]){
        [MobClick event:@"searchokoer"];
    } else if ([viewController.childViewControllers[0] isKindOfClass:[OBPersonalViewController class]]){
        [MobClick event:@"aboutokoer"];
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

@end
