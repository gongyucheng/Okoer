//
//  OBAccountTool.m
//  YouKe
//
//  Created by obally on 15/7/23.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBAccountTool.h"
// 账号的存储路径
#define HWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]
#define HWLastAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"lastAccount.archive"]

@implementation OBAccountTool
/**
*  存储账号信息
*
*  @param account 账号模型
*/
+ (void)saveAccount:(OBAccount *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:HWAccountPath];
//    [self saveLastAccount:account];
}

+ (void)saveLastAccount:(OBAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:HWLastAccountPath];
}
+ (OBAccount *)getLastAccount
{
    // 加载模型
    OBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HWLastAccountPath];
    return account;
}
/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (OBAccount *)account
{
    // 加载模型
    OBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HWAccountPath];
    // 过期的秒数
    long long expires_in = 2*60;
    // 获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    // 获得当前时间
    NSDate *now = [NSDate date];
    
    // 如果expiresTime <= now，过期
    /**
     NSOrderedAscending = -1L, 升序，右边 > 左边
     NSOrderedSame, 一样
     NSOrderedDescending 降序，右边 < 左边
     */
    NSComparisonResult result = [expiresTime compare:now];
//    if (result != NSOrderedDescending) { // 过期
//        //发送token 过期的消息
//        [OBNotificationCenter postNotificationName:@"OBTokenExpiredNotication" object:nil];
////        return nil;
//    }

    return account;
}
+ (void)deleteAccount
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:HWAccountPath]) {
        [defaultManager removeItemAtPath:HWAccountPath error:nil];
    }
}
- (void)setAccount:(OBAccount *)account
{
    if (_account != account) {
        _account = [self account];
    }
}
@end
