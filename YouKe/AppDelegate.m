//
//  AppDelegate.m
//  YouKe
//
//  Created by obally on 15-7-22.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "APService.h"
#import "OBKWDetailViewController.h"
#import "OBKPDetailViewController.h"

@interface AppDelegate ()<UIAlertViewDelegate>
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic)BOOL isFull;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
     [self.window switchRootViewController];
    // 2.设置根控制器
       // 3.显示窗口
    [self.window makeKeyAndVisible];
    if ([OBManager sessionManager].mode == OBSessionModeOffline) {
        [KLToast showToast:@"当前网络不可用"];
    }
    [ShareSDK registerApp:ShareAPPID];
    //    [Parse setApplicationId:ParseApplicationId clientKey:ParseClientKey];
    //新浪微博登录
    [ShareSDK connectSinaWeiboWithAppKey:SinaWeiBoAppKey
                               appSecret:SinaWeiBoAppSecret
                             redirectUri:SinaRredirectUri];
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:TengXunAppKey
                           appSecret:TengXunAppSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:TengXunAppKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //微信
    [ShareSDK connectWeChatWithAppId:WeiXinAPPID
                           wechatCls:[WXApi class]];
    [ShareSDK connectMail];
    
    [MobClick startWithAppkey:@"55de823c67e58ee9d1000fc0" reportPolicy:SEND_INTERVAL   channelId:@"APP Store"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    // Required  集成极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //获取iOS的推送内容
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (fullScreenStarted:) name : @"OBPhotoBrowserDidEnterFullscreenNotification" object : nil ];
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (fullScreenFinished:) name : @"OBPhotoBrowserDidExitFullscreenNotification" object : nil ];
    return YES;
}
- ( void )fullScreenStarted:( NSNotification *)notification {
    
    self. isFull = YES ;
    
}

- ( void )fullScreenFinished:( NSNotification *)notification {
    
//    AppDelegate *appDelegate = [[ UIApplication sharedApplication ] delegate ];
    
    self.isFull = NO ;
    
    if ([[ UIDevice currentDevice ] respondsToSelector : @selector (setOrientation:)]) {
        
        SEL selector = NSSelectorFromString ( @"setOrientation:" );
        
        NSInvocation *invocation = [ NSInvocation invocationWithMethodSignature :[ UIDevice instanceMethodSignatureForSelector :selector]];
        
        [invocation setSelector :selector];
        
        [invocation setTarget :[ UIDevice currentDevice ]];
        
        int val = UIInterfaceOrientationPortrait ;
        
        [invocation setArgument :&val atIndex : 2 ];
        
        [invocation invoke ];
        
    }
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_isFull) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    NSDictionary *userInfo = notification.userInfo;
    self.userInfo = userInfo;
    NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"优恪消息推送" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
    [alert show];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
    
}
//极光配置
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    
    UIApplicationState state = [application applicationState];
    
//    BOOL isActive = NO;
    
    if (state == UIApplicationStateActive) {
//        isActive = YES;
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }else {
        [APService handleRemoteNotification:userInfo];
        [self praseDataWithRemoteInfo:userInfo];
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
   
    UIApplicationState state = [application applicationState];
    
//    BOOL isActive = NO;
    
    if (state == UIApplicationStateActive) {
//        isActive = YES;
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }else {
        [APService handleRemoteNotification:userInfo];
       
         [self praseDataWithRemoteInfo:userInfo];
    }
     completionHandler(UIBackgroundFetchResultNewData);
   
}
- (void)praseDataWithRemoteInfo:(NSDictionary *)userInfo
{
    NSLog(@"------presentedViewController----------------%@",self.window.rootViewController.presentedViewController);
    NSLog(@"------self.window.viewController----------------%@",[[self.window subviews]lastObject].viewController);
    NSLog(@"------presentingViewController----------------%@",self.window.rootViewController.presentingViewController);
    NSLog(@"------------rootViewController----------%@",self.window.rootViewController);
    NSString *page = userInfo[@"page"];
    if ([page isEqualToString:@"kwdetail"]) {
        OBKWDetailViewController *kwDetail = [[OBKWDetailViewController alloc]init];
        NSString *pageId = userInfo[@"pageId"];
        kwDetail.pageId = [pageId integerValue];
        if (self.window.rootViewController.presentedViewController) {

            [[self topviewcontroller] presentViewController:kwDetail animated:YES completion:nil];
        } else
            [self.window.rootViewController presentViewController:kwDetail animated:YES completion:nil];
    } else if ([page isEqualToString:@"kpdetail"]) {
        OBKPDetailViewController *kpDetail = [[OBKPDetailViewController alloc]init];
        NSString *pageId = userInfo[@"pageId"];
        kpDetail.pageId = [pageId integerValue];
        if (self.window.rootViewController.presentedViewController) {
            [[self topviewcontroller] presentViewController:kpDetail animated:YES completion:nil];
        } else
        [self.window.rootViewController presentViewController:kpDetail animated:YES completion:nil];
    }
}

- (UIViewController *)topviewcontroller
{
    UIViewController *next = self.window.rootViewController.presentedViewController;
    if (next) {
        do {
            UIViewController *viewController = next;
            next = next.presentedViewController;
            if (![next isKindOfClass:[UIViewController class]]) {
                return viewController;
            }
            
        } while (next != nil);
    }
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
 
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self praseDataWithRemoteInfo:self.userInfo];
    } else {
    
    }
}
@end
