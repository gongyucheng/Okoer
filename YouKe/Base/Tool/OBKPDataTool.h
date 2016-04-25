//
//  OBKPDataTool.h
//  YouKe
//
//  Created by obally on 15/7/25.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OBKPListModel;
@interface OBKPDataTool : NSObject
+(NSArray *)listModels;
+(void)addListModel:(OBKPListModel *)listModel;
+ (void)deleSql;
+(BOOL)isSameListModelWithModel:(OBKPListModel *)model;
@end
