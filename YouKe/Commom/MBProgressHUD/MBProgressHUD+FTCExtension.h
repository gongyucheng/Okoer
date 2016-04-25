//
//  MBProgressHUD+FTCExtension.h
//  KangLoveDefender
//
//  Created by Obally on 15/5/13.
//  Copyright (c) 2015年 Obally. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (FTCExtension)
+ (MBProgressHUD *)mbProgressHudInView:(UIView *)view;

/**
 *  文字提示
 *
 * 一秒后自动删除
 *  @param alertString 提示的内容
 */
+ (void)showAlert:(NSString *)alertString;


/**
 *  文字提示
 *
 *  @param alertString 提示的内容
 *  @param time        显示多久
 */
+ (void)showAlert:(NSString *)alertString
             time:(int)time;


/**
 *  文字提示
 *  不自动删除
 *  默认添加到window上面
 *  @param message 提示的内容
 */
+ (void)startWaitWithMessage:(NSString *)message;

/**
 *  开始提示，不自动删除
 *  @param message 提示的内容
 *  @param view    添加到view上面
 */
+ (void)startWaitWithMessage:(NSString *)message inView:(UIView *)view;

/**
 *  结束到window上提醒
 *
 */
+ (void)stopWait;

/**
 *  结束到view上的提醒
 *
 */
+ (void)stopWaitWithView:(UIView *)view;


@end
