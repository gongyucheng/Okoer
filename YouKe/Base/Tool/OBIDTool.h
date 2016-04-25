//
//  OBIDTool.h
//  YouKe
//
//  Created by obally on 15/9/5.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBGuangGaoModel.h"
@interface OBIDTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(OBGuangGaoModel *)guangGao;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (OBGuangGaoModel *)guangGao;
+ (void)deleteGuanggaoModel;
@end
