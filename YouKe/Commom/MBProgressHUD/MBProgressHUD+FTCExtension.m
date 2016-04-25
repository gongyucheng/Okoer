//
//  MBProgressHUD+FTCExtension.m
//  KangLoveDefender
//
//  Created by Obally on 15/5/13.
//  Copyright (c) 2015年 Obally. All rights reserved.
//

static const int MBProgressHUD_VIEW_TAG = 4555;

#import "MBProgressHUD+FTCExtension.h"

#import "AppDelegate.h"
@implementation MBProgressHUD (FTCExtension)

+ (UIWindow *)applicationWindow{

    return [[UIApplication sharedApplication].windows lastObject];
}

+ (MBProgressHUD *)mbProgressHudInView:(UIView *)view{
 
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.tag = MBProgressHUD_VIEW_TAG;
    hud.detailsLabelFont = [UIFont systemFontOfSize:17];
    hud.labelFont = [UIFont systemFontOfSize:17];
    [hud show:YES];
    hud.hidden = NO;
    return  hud;
}

#pragma mark -
#pragma mark 提示
+ (void)showAlert:(NSString *)alertString{
    
    [self showAlert:alertString time:1];
}

+ (void)showAlert:(NSString *)alertString time:(int)time{
    
    UIWindow *window = [self applicationWindow];
    MBProgressHUD * hud = [[self alloc] initWithView:window];
    [window addSubview:hud];
    hud.labelText = alertString;
    hud.labelFont = [UIFont systemFontOfSize:KFont(14.0)];
    hud.mode=MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(time);
    }completionBlock:^{
        [hud removeFromSuperview];
    }];
}

BOOL MBProgressHUDStartStatus = NO;

+ (void)startWaitWithMessage:(NSString *)message{
    [self startWaitWithMessage:message inView:nil];
}

+ (void)startWaitWithMessage:(NSString *)message inView:(UIView *)view{
    if (view == nil) {
        view = [self applicationWindow];
    }
    
    NSAssert([NSThread isMainThread], @"startWaitWithMessage must in main thread");
    MBProgressHUDStartStatus = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if (MBProgressHUDStartStatus == NO) {
            return ;
        }
        MBProgressHUD * hud = [self showHUDAddedTo:view animated:YES];
        hud.labelText = message;
        hud.removeFromSuperViewOnHide = YES;
        hud.mode=MBProgressHUDModeIndeterminate;
        hud.tag = MBProgressHUD_VIEW_TAG;
        [view addSubview:hud];
    });
}

+ (void)stopWait{
    
    [self stopWaitWithView:nil];
}

+ (void)stopWaitWithView:(UIView *)view{
   
    if (view == nil) {
       view = [self applicationWindow];
    }
    
    MBProgressHUDStartStatus = NO;
    MBProgressHUD * hud = (MBProgressHUD *)[view viewWithTag:MBProgressHUD_VIEW_TAG];
    hud.hidden = YES;
    [hud removeFromSuperview];
}

@end
