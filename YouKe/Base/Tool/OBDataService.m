//
//  OBDataService.m
//  OBNewCar
//
//  Created by Obally on 14-9-25.
//  Copyright (c) 2014年 jiebao. All rights reserved.
//

#import "OBDataService.h"
#import "OBHTTPRequsetOperation.h"
@implementation OBDataService
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)urlstring
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                           completionblock:(CompletionLoadHandle)completionBlock
                               failedBlock:(FailedLoadBlock)failedBlock
{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    //创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //加载.cer 文件  验证其唯一性  是不是来源于服务器
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ios_user(tester)" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setPinnedCertificates:@[certData]];
    [securityPolicy setSSLPinningMode:AFSSLPinningModeCertificate];
    AFHTTPRequestOperation *operation = nil;
    manager.securityPolicy = securityPolicy;
    if ([httpMethod isEqualToString:@"GET"]) {
        //发送GET请求
        operation = [manager GET:urlstring
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if (completionBlock != nil) {
                                completionBlock(responseObject);
                             }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            if (failedBlock != nil) {
                                failedBlock([error localizedDescription]);
                            }
//                            [KLToast showToast:[error localizedDescription]];
                            OBLog(@"请求网络失败：%@",error);
                        }];
    } else if ([httpMethod isEqualToString:@"POST"]) {
        //发送POST请求
        BOOL isFile = NO;
        for (NSString *key in params) {
            id value = params[key];
            if (value != nil) {
                if ([value isKindOfClass:[NSData class]]) {
                    isFile = YES;
                    break;
                }
            }
        }
        if (!isFile) {
            //如果参数中没有文件
            operation = [manager POST:urlstring
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   OBLog(@"operation.responseString = %@",operation.responseString);
                                   OBLog(@"responseObject = %@",operation.responseObject);
                                  if (completionBlock != nil) {
                                      completionBlock(responseObject);
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  if (failedBlock != nil) {
                                      failedBlock([error localizedDescription]);
                                  }
//                                [KLToast showToast:[error localizedDescription]];
                                  OBLog(@"请求网络失败：%@",error);
                              }];
            } else {
                //如果参数中带有参数
                operation = [manager POST:urlstring
                               parameters:params
                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                    for (NSString *key in params) {
                                        id value = params[key];
                                        if ([value isKindOfClass:[NSData class]]) {
                                            //将文件添加到formData中
                                            [formData appendPartWithFileData:value
                                                                        name:key
                                                                    fileName:key
                                                                    mimeType:@"image/jpeg"];
                                        }
                                    }
                }
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if (completionBlock != nil) {
                                          completionBlock(responseObject);
                                      }
                                       OBLog(@"response:%@",operation.response.allHeaderFields);
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      if (failedBlock != nil) {
                                          failedBlock([error localizedDescription]);
                                      }
//                                      [KLToast showToast:[error localizedDescription]];
                                      OBLog(@"请求网络失败：%@",error);
                                      
                                  }];
            }
    }
   
    //设置返回数据的解析方式
    operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    return operation;
}

@end
