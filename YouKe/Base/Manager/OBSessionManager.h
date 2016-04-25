//
//  OBSessionManager.h
//  YouKe
//
//  Created by obally on 15/7/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBAccount.h"
/// notification type
extern NSString *const ppy_notification_session_mode_changed;
extern NSString *const ppy_notification_session_status_changed;

typedef enum {
    OBSessionModeOffline = 0,
    OBSessionModeOnline
}OBSessionMode;

typedef enum {
    OBSessionStatusLogout = 0,
    OBSessionStatusLogin
}OBSessionStatus;

@interface OBSessionManager : NSObject
@property (nonatomic,readonly)OBSessionMode mode;
@property (nonatomic,readonly)OBSessionStatus status;
@property (nonatomic, retain) OBAccount *accountModel;
- (void)logout;
- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord imei:(NSString *)imei callback:(void(^)(BOOL success, NSString *msg))callback;
@end
