//
//  UIView+ContainerViewController.m
//  YouKe
//
//  Created by obally on 15/7/27.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "UIView+ContainerViewController.h"
#import "OBContainerViewController.h"
#import "OBRecommendController.h"
#import "OBYKGradeViewController.h"
#import "OBGradeListController.h"
#import "OBSearchDetailController.h"
#import "OBSingleBrandViewController.h"
#import "OBKeWenAndKePingController.h"
#import "OBKeWenViewController.h"

@implementation UIView (ContainerViewController)

- (UIViewController *)containerViewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[OBContainerViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (UINavigationController *)navController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (UIViewController *)kewenAndKePingController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[OBKeWenAndKePingController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

- (UIViewController *)recommendController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[OBRecommendController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
  return nil;
}

- (UIViewController *)gradeViewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[OBYKGradeViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (UIViewController *)kewenController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[OBKeWenViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (UIViewController *)gradeListController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[OBGradeListController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (UIViewController *)searchDetailController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[OBSearchDetailController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (UIViewController *)singleBrandController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[OBSingleBrandViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
+ (BOOL)isCurrentVersion
{
    //新手介绍
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if (![currentVersion isEqualToString:lastVersion]) {
        return NO;
    } else
        return YES;
}
+ (void)saveVersion
{
    //新手介绍
    NSString *key = @"CFBundleVersion";
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
@end
