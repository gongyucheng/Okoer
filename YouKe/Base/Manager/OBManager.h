//
//  OBManager.h
//  YouKe
//
//  Created by obally on 15/7/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBSessionManager.h"
#import "OBAccountTool.h"

#define OB_SINGLETON(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}
@interface OBManager : NSObject
#pragma mark - Global : for all user
+ (OBSessionManager *)sessionManager;
+ (OBAccountTool *)accountManager;
#pragma mark - Control interface
+ (BOOL)isOfflineMode;
+ (void)showNetworkActivityIndicator;
+ (void)hideNetworkActivityIndicator;
@end
