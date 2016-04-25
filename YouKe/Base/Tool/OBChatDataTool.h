//
//  OBChatDataTool.h
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OBChatListModel;
@interface OBChatDataTool : NSObject
+ (void)deleSql;
+(NSArray *)listModels;
+(void)addListModel:(OBChatListModel *)listModel;
+(BOOL)isSameListModelWithModel:(OBChatListModel *)model;
@end
