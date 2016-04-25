//
//  OBMyCityViewController.m
//  YouKe
//
//  Created by obally on 15/8/17.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBMyCityViewController.h"

@interface OBMyCityViewController ()

@end

@implementation OBMyCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    self.view.backgroundColor = HWRandomColor;
    // Do any additional setup after loading the view.
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
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(KbuttonEdgeWidth, kScreenHeight - KbuttonEdgeWidth - KbuttonWidth, KbuttonWidth, KbuttonWidth)];
    //    backButton.backgroundColor = HWRandomColor;
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_0001_Return48"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = backButton.width/2;
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
- (void)backButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
