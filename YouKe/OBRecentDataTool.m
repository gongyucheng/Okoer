//
//  OBRecentDataTool.m
//  YouKe
//
//  Created by obally on 15/10/27.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import "OBRecentDataTool.h"
// 账号的存储路径
#define HWRecentPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentData.archive"]
@implementation OBRecentDataTool
+ (void)saveRecentData:(NSMutableArray *)datas;
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:datas toFile:HWRecentPath];
}

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (NSMutableArray *)recentDatas
{
    // 加载模型
    NSMutableArray *recentDatas = [NSKeyedUnarchiver unarchiveObjectWithFile:HWRecentPath];
    
    return recentDatas;
}
@end
