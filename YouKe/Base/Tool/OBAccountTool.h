//
//  OBAccountTool.h
//  YouKe
//
//  Created by obally on 15/7/23.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBAccount.h"
@interface OBAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(OBAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (OBAccount *)account;
+ (void)deleteAccount;
//用于登录时获取上一次的登录用户
+ (OBAccount *)getLastAccount;

+ (void)saveLastAccount:(OBAccount *)account;
@property (nonatomic, retain) OBAccount *account;
@end
