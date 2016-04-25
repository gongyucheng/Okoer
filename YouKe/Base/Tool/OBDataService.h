//
//  OBDataService.h
//  OBNewCar
//
//  Created by Obally on 14-9-25.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^CompletionLoadHandle)(id result);
typedef void(^FailedLoadBlock )(id error);
@interface OBDataService : NSObject

/**
 *   AFNetWorking 封装的网络请求
 *
 *  @param urlstring  请求的URL
 *  @param params     参数
 *  @param httpMethod 请求方式
 *  @param block      完成回调的block
 *
 *  @return 返回的operation
 */
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)urlstring
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                           completionblock:(CompletionLoadHandle)completionBlock
                               failedBlock:(FailedLoadBlock)failedBlock;
/**
 *  AFNetWorking 封装的登录
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *  @param block    登录之后回调的block
 *
 *  @return 返回的operation
 */
//+ (AFHTTPRequestOperation *)requestLogin:(NSString *)userName
//                                password:(NSString *)passWord
//                                   block:(CompletionLoadHandle)block;

@end
