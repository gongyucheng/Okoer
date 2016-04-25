//
//  OBIDTool.m
//  YouKe
//
//  Created by obally on 15/9/5.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBIDTool.h"

// 账号的存储路径
#define HWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"guanggao.archive"]

@implementation OBIDTool
/**
 *  存储广告信息
 *
 *  @param account 广告模型
 */
+ (void)saveAccount:(OBGuangGaoModel *)guangGao
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:guangGao toFile:HWAccountPath];
}

/**
 *  返回广告信息
 *
 *  @return 广告模型（如果广告过期，返回nil）
 */
+ (OBGuangGaoModel *)guangGao
{
    // 加载模型
    OBGuangGaoModel *guangGao = [NSKeyedUnarchiver unarchiveObjectWithFile:HWAccountPath];
    
    return guangGao;
}

+ (void)deleteGuanggaoModel;
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:HWAccountPath]) {
        [defaultManager removeItemAtPath:HWAccountPath error:nil];
    }
}

@end

