//
//  OBRecentDataTool.h
//  YouKe
//
//  Created by obally on 15/10/27.
//  Copyright © 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBRecentDataTool : NSObject
/**
 *  存储最近搜索信息
 *
 *  @param datas 搜索
 */
+ (void)saveRecentData:(NSMutableArray *)datas;

/**
 *  返回最近搜索信息
 *
 *  @return 最近搜索信息
 */
+ (NSMutableArray *)recentDatas;

@end
