//
//  OBJBKPDataTool.m
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBJBKPDataTool.h"
#import "FMDB.h"
#import "OBKPListModel.h"
#import "OBKWListModel.h"
// 账号的存储路径
#define HWRecommendPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recommend.archive"]
@implementation OBJBKPDataTool
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveJianBianData:(NSArray *)recommends
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:recommends toFile:HWRecommendPath];
}

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (NSArray *)recommends
{
    // 加载模型
    NSArray *recommends = [NSKeyedUnarchiver unarchiveObjectWithFile:HWRecommendPath];
    
    return recommends;
}

@end

