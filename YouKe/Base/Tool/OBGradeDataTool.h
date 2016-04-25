//
//  OBGradeDataTool.h
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OBGradeModel;
@interface OBGradeDataTool : NSObject
+ (void)deleSql;
+(NSArray *)listModels;
+(void)addListModel:(OBGradeModel *)listModel;
+(BOOL)isSameListModelWithModel:(OBGradeModel *)model;
@end
