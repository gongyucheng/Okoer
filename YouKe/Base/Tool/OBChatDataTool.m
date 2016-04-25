//
//  OBChatDataTool.m
//  YouKe
//
//  Created by obally on 15/8/18.
//  Copyright (c) 2015年 ___shangyait___. All rights reserved.
//

#import "OBChatDataTool.h"
#import "FMDB.h"
#import "OBChatListModel.h"

@implementation OBChatDataTool
static FMDatabase *_db;
+ (void)initialize
{
    
    //1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"chatListModel.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
//    [_db executeUpdate:@"DROP TABLE OBChatListModel"];
    //2.创表  资讯列表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS OBChatListModel (nid real,category text,changed_time real ,chat_count real ,created_time real,img_uri text,last_message text,last_user text ,last_user_img_uri text,publisher text,status text,subtitle text,summary text,title text )"];
}

+(NSArray *)listModels
{
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM OBChatListModel"];
    NSMutableArray *chatListModels = [NSMutableArray array];
    while (set.next) {
        OBChatListModel *chatListModel = [[OBChatListModel alloc]init];
        chatListModel.nid = [set doubleForColumn:@"nid"];
        chatListModel.category = [set stringForColumn:@"category"];
        chatListModel.changed_time = [set doubleForColumn:@"changed_time"];
        chatListModel.chat_count = [set doubleForColumn:@"chat_count"];
        chatListModel.created_time = [set doubleForColumn:@"created_time"];
        chatListModel.img_uri = [set stringForColumn:@"img_uri"];
        chatListModel.last_message = [set stringForColumn:@"last_message"];
        chatListModel.last_user = [set stringForColumn:@"last_user"];
        chatListModel.last_user_img_uri = [set stringForColumn:@"last_user_img_uri"];
        chatListModel.publisher = [set stringForColumn:@"publisher"];
        chatListModel.status = [set stringForColumn:@"status"];
        chatListModel.subtitle = [set stringForColumn:@"subtitle"];
        chatListModel.summary = [set stringForColumn:@"summary"];
        chatListModel.title = [set stringForColumn:@"title"];
        [chatListModels addObject:chatListModel];
    }
    return chatListModels;
}

+(void)addListModel:(OBChatListModel *)listModel
{
    [_db executeUpdateWithFormat:@"INSERT INTO OBChatListModel (nid, category,changed_time,chat_count,created_time,img_uri, last_message,last_user,last_user_img_uri,publisher,status,subtitle,summary,title) VALUES (%ld,%@,%ld,%ld,%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@);",listModel.nid,listModel.category,listModel.changed_time,listModel.chat_count,listModel.created_time,listModel.img_uri,listModel.last_message,listModel.last_user,listModel.last_user_img_uri,listModel.publisher,listModel.status,listModel.subtitle,listModel.summary,listModel.title];
}

+(BOOL)isSameListModelWithModel:(OBChatListModel *)model
{
    NSString *base = @"SELECT * FROM OBChatListModel WHERE nid = %ld";
    NSString *text = [NSString stringWithFormat:base,model.nid];
    FMResultSet *set = [_db executeQuery:text];
    if (set.next) {
        return YES;
    } else
        return NO;
}
+ (void)deleSql
{
    [_db executeUpdate:@"DELETE FROM OBChatListModel;"];
}
@end