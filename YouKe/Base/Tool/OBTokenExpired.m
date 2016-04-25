//
//  OBTokenExpired.m
//  YouKe
//
//  Created by obally on 15/9/10.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBTokenExpired.h"
#import "NSString+Hash.h"

@implementation OBTokenExpired
+ (void)tokenExPiredWithControllerTarget:(id)target WithSelector:(SEL)aSelector
{
    OBAccount *account = [OBAccountTool account];
   
    if (account.isOKerLogin) {
        //okoer 登录
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:account.name forKey:@"username"];
        if (account.passWord.length == 0) {
            account.passWord = @" ";
        }
        [params setObject:account.passWord forKey:@"password"];
        if (account.imei.length == 0) {
            account.imei = @" ";
        }
        [params setObject:account.imei forKey:@"imei"];

        [OBDataService requestWithURL:OBOkoerLoginURL params:params httpMethod:@"POST" completionblock:^(id result) {
            NSString *err = result[@"err_msg"];
            if ([err isEqualToString:@"ok"]) {
                NSDictionary *dic = result[@"result"];
                OBAccount *accountModel = [OBAccount objectWithKeyValues:dic];
                accountModel.isOKerLogin = YES;
                accountModel.isSinaLogin = NO;
                accountModel.isQQLogin = NO;
                accountModel.passWord = account.passWord;
                accountModel.imei = account.imei;
                [OBAccountTool saveAccount:accountModel];
                [OBAccountTool saveLastAccount:accountModel];
                SuppressPerformSelectorLeakWarning(
                [target performSelector:aSelector withObject:nil];
                );
                
            } else if ([err isEqualToString:@"error"]) {
                NSString *errSting = result[@"result"];
                [MBProgressHUD showAlert:errSting];
            }
        } failedBlock:^(id error) {
            [MBProgressHUD showAlert:error];
        }];

    } else {
        NSString *uid = account.sid;
        if (uid == nil) {
            uid = @"";
        }
        NSString *nickName = account.name;
        
//        NSString *profileUrl = account.icon;
        NSString * cpuTType;
        if (account.isSinaLogin) {
            cpuTType = @"weibo";
        } else if (account.isQQLogin) {
            cpuTType = @"qq";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (nickName != nil) {
            [params setObject:nickName forKey:@"username"];
        }
        if (cpuTType != nil) {
            [params setObject:cpuTType forKey:@"platform"];
        }
        if (uid != nil) {
            [params setObject:uid forKey:@"id"];
        }
        if (account.imei != nil) {
            [params setObject:account.imei forKey:@"imei"];
        }
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeInterval =[date timeIntervalSince1970] ;
        NSString *timeString = [NSString stringWithFormat:@"%d",(int)timeInterval];
        NSString *key = @"yaochizaocan";
        NSString *sign = [[NSString stringWithFormat:@"%@%@%@",key,timeString,account.imei]md5String];
        [params setObject:sign forKey:@"key"];
        [params setObject:timeString forKey:@"time"];
        [OBDataService requestWithURL:OBOkoerRegisterURL params:params httpMethod:@"POST" completionblock:^(id result) {
            NSNumber *code = result[@"ret_code"];
            if ([code integerValue] == 0) {
                NSDictionary *dic = result[@"result"];
                OBAccount *accountModel = [OBAccount objectWithKeyValues:dic];
                accountModel.icon = accountModel.icon;
                if (account.isSinaLogin) {
                    accountModel.isSinaLogin = YES;
                    accountModel.isQQLogin = NO;
                    accountModel.isOKerLogin = NO;
                } else if (account.isQQLogin) {
                    accountModel.isSinaLogin = NO;
                    accountModel.isQQLogin = YES;
                    accountModel.isOKerLogin = NO;
                }
                accountModel.sid = uid;
                accountModel.imei = account.imei;
                [OBAccountTool saveAccount:accountModel];
                accountModel.created_time = date;
                SuppressPerformSelectorLeakWarning(
                                                   [target performSelector:aSelector withObject:nil];
                                                   );

            }else{
                NSString *errSting = result[@"err_msg"];
                [MBProgressHUD showAlert:errSting];

            }
            
        } failedBlock:^(id error) {
            [MBProgressHUD showAlert:error];
        }];

        
    }
}

@end
