//
//  OBSessionManager.m
//  YouKe
//
//  Created by obally on 15/7/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBSessionManager.h"


/// notification type
NSString *const ppy_notification_session_mode_changed = @"ppy_notification_session_mode_changed";
NSString *const ppy_notification_session_status_changed = @"ppy_notification_session_status_changed";

@interface OBSessionManager ()
@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@end

@implementation OBSessionManager
@synthesize mode = _mode;
@synthesize status = _status;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    if (self) {
        
        [self setupNotificationsObserver];
        [self startNetworkStatusNotifier];
    }
    return self;
}

- (OBSessionStatus)status
{
    if ([OBAccountTool account]) {
        _status = OBSessionStatusLogin;
    } else
        _status = OBSessionStatusLogout;
    return _status;
}

- (void)logout
{
    _status = OBSessionStatusLogout;
    [OBAccountTool deleteAccount];
}

- (void)startSyncdata
{
    
}

- (void)setupNotificationsObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
}

- (void)startNetworkStatusNotifier {
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(startNetworkStatusNotifier) withObject:nil waitUntilDone:YES];
        return ;
    }
    _internetReach = [Reachability reachabilityForInternetConnection];
    _wifiReach = [Reachability reachabilityForLocalWiFi];
    
    if ([_internetReach isReachableViaWWAN]) {
        [_internetReach startNotifier];
        [self updateInterfaceWithReachability:_internetReach];
    } else if ([_internetReach isReachableViaWiFi]) {
         [_wifiReach startNotifier];
        [self updateInterfaceWithReachability:_wifiReach];
    } else {
        [MBProgressHUD showAlert:@"当前网络不可用"];
//        [KLToast showToast:@"当前网络不可用"];
    }


}

- (void)updateInterfaceWithReachability:(Reachability *)curReach
{
//   BOOL wwan = [curReach isReachableViaWWAN];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == kReachableViaWWAN || netStatus == kReachableViaWiFi) {
        _mode = OBSessionModeOnline;
    } else {
         _mode = OBSessionModeOffline;
        
    }

    
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    OBSessionMode oldMode = self.mode;
    [self updateInterfaceWithReachability:curReach];
    OBSessionMode newMode = self.mode;
    if (oldMode != newMode) {
        [self postModeChangedNotification];
    }
    if (newMode == OBSessionModeOffline) {
        
    }
}

- (void)postModeChangedNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ppy_notification_session_mode_changed object:nil];
}
- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord imei:(NSString *)imei callback:(void(^)(BOOL success, NSString *msg))callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userName forKey:@"username"];
    [params setObject:passWord forKey:@"password"];
    [params setObject:imei forKey:@"imei"];
    [OBDataService requestWithURL:OBOkoerLoginURL params:params httpMethod:@"POST" completionblock:^(id result) {
        NSDate *date = [NSDate date];
        NSString *err = result[@"err_msg"];
        if ([err isEqualToString:@"ok"]) {
            if(callback){
                callback(YES,nil);
            }
            NSDictionary *dic = result[@"result"];
            OBAccount *accountModel = [OBAccount objectWithKeyValues:dic];
            accountModel.created_time = date;
            accountModel.passWord = passWord;
            accountModel.imei = imei;
            accountModel.isOKerLogin = YES;
            accountModel.isSinaLogin = NO;
            accountModel.isQQLogin = NO;
            [OBAccountTool saveAccount:accountModel];
            [OBAccountTool saveLastAccount:accountModel];
            [OBNotificationCenter postNotificationName:@"LoginNotifiCation" object:nil];
//            _accountModel = accountModel;
        } else if ([err isEqualToString:@"error"]) {
//            NSString *errSting = result[@"result"];
            if(callback){
                callback(NO,nil);
            }
            [MBProgressHUD showAlert:@"账号密码不匹配"];
        }
    } failedBlock:^(id error) {
        if(callback){
            callback(NO,nil);
        }
        [MBProgressHUD showAlert:error];
    }];

}
@end
