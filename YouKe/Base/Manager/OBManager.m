//
//  OBManager.m
//  YouKe
//
//  Created by obally on 15/7/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBManager.h"
//#import "MBProgressHUD+FTCExtension.h"

@interface OBManager ()

@property (nonatomic, strong) OBSessionManager *session;
@property (nonatomic, strong) OBAccountTool *accountTool;
@property (nonatomic, assign) int networkActivityShowCount;
@end

@implementation OBManager
OB_SINGLETON(OBManager);
#pragma mark - Global : for all user
+ (OBSessionManager *)sessionManager
{
    return [OBManager sharedInstance].session;
}

+ (OBAccountTool *)accountManager
{
    return [OBManager sharedInstance].accountTool;
}

#pragma mark - Control interface
+ (BOOL)isOfflineMode
{
    return [[OBManager sessionManager] mode] == OBSessionModeOffline;
}
+ (void)showNetworkActivityIndicator {
    
    [[OBManager sharedInstance] showNetworkActivityIndicator];
}
+ (void)hideNetworkActivityIndicator {
    
    [[OBManager sharedInstance] hideNetworkActivityIndicator];
}

- (void)dealloc
{
    [OBNotificationCenter removeObserver:self];
}
- (id)init {
    self = [super init];
    if (self) {

        self.session = [[OBSessionManager alloc] init];
        
        [OBNotificationCenter addObserver:self selector:@selector(receivedNotification:) name:ppy_notification_session_mode_changed object:nil];
        [OBNotificationCenter addObserver:self selector:@selector(receivedNotification:) name:ppy_notification_session_status_changed object:nil];

    }
    return self;
}
- (void)showNetworkActivityIndicator {
    
    _networkActivityShowCount++;
    
    if (_networkActivityShowCount > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
    }
}

- (void)hideNetworkActivityIndicator {
    
    _networkActivityShowCount--;
    
    if (_networkActivityShowCount <= 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
}
- (void)receivedNotification:(NSNotification *)notification
{
    NSString *name = notification.name;
    //    NSDictionary *userinfo = notification.userInfo;
    
    if ([name isEqualToString:ppy_notification_session_mode_changed]) {
        
        if ([OBManager isOfflineMode]) {
            //离线
            [MBProgressHUD showAlert:@"当前网络不可用"];
//            [KLToast showToast:@"当前网络不可用"];
        }
        else {
            //在线
            
        }
        
    }
}
@end
