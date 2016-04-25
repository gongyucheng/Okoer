//
//  UIView+ContainerViewController.h
//  YouKe
//
//  Created by obally on 15/7/27.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ContainerViewController)
- (UIViewController *)containerViewController;
- (UIViewController *)viewController;
- (UIViewController *)recommendController;
- (UIViewController *)gradeViewController;
- (UIViewController *)gradeListController;
- (UIViewController *)searchDetailController;
- (UIViewController *)singleBrandController;
- (UIViewController *)kewenAndKePingController;
- (UIViewController *)kewenController;
- (UINavigationController *)navController;
//+ (BOOL)isCurrentVersion;
//+ (void)saveVersion;
//@end
