//
//  OBNewfeatureController.m
//  YouKe
//
//  Created by obally on 15/7/23.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBNewfeatureController.h"
#import "OBRecommendController.h"
#import "OBGuangGaoModel.h"
#import "OBIDTool.h"
#import "OBContainerViewController.h"
#import "OBTabBarController.h"
#define HWNewfeatureCount 3

@interface OBNewfeatureController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation OBNewfeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadguangGao];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i<HWNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"introduce_%d_1080x1920", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == HWNewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(HWNewfeatureCount * scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = HWNewfeatureCount;
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = HWColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = HWColor(189, 189, 189);
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;

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
        NSDictionary *dic = array[0];
        OBGuangGaoModel *model = [OBGuangGaoModel objectWithKeyValues:dic];
        model.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.img_uri]]];
        [OBIDTool saveAccount:model];
        
    }
    
    
}
/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    
    // 2.开始微博
    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.frame = CGRectMake(kScreenWidth/2 - KViewWidth(75), kScreenHeight - KViewHeight(150), KViewWidth(150), KViewHeight(44));
    UIImage *image = [UIImage imageNamed:@"start"];
    image = [image stretchableImageWithLeftCapWidth:20  topCapHeight:20];
    [startBtn setBackgroundImage:image forState:UIControlStateNormal];
    [startBtn setTitle:@"进入优恪生活" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}

- (void)startClick
{
    // 切换到HWTabBarController
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     */
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    OBContainerViewController *recommend = [[OBContainerViewController alloc] init];
////    recommend.isFirstLoad = YES;
//    [recommend loadOpenView];
//     window.rootViewController = recommend;
    OBTabBarController *tab = [[OBTabBarController alloc]init];
    [tab loadOpenView];
    window.rootViewController = tab;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    // 四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
}


@end
