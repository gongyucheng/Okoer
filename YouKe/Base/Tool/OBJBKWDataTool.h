//
//  OBJBKWDataTool.h
//  YouKe
//
//  Created by obally on 15/8/19.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OBKWListModel;
@interface OBJBKWDataTool : NSObject
+ (void)deleSql;
+(NSArray *)listModels;
+(void)addListModel:(OBKWListModel *)listModel;
@end
