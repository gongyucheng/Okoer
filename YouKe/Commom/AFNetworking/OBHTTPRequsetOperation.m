//
//  OBHTTPRequsetOperation.m
//  YouKe
//
//  Created by obally on 15/8/30.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBHTTPRequsetOperation.h"

@implementation OBHTTPRequsetOperation
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    if ([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        if ([self bypassSslCertValidation:protectionSpace])
            return YES;
        else
            return [super connection:connection canAuthenticateAgainstProtectionSpace:protectionSpace];
        
    }
    return [super connection:connection canAuthenticateAgainstProtectionSpace:protectionSpace];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self bypassSslCertValidation:challenge.protectionSpace]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
            return;
        }
        else
            return [super connection:connection didReceiveAuthenticationChallenge:challenge];
        return;
    }
}

- (BOOL) bypassSslCertValidation:(NSURLProtectionSpace *) protectionSpace
{
//    if (ENVIRONMENT_TYPE == DEV_ENV || ENVIRONMENT_TYPE == STAGING_ENV) {
//        return YES;
//    }
    return NO;
}
@end
